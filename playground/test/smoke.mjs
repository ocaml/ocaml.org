// Smoke test of the built playground: serve playground/asset/ with the
// harness page, drive it in headless Chrome, check what the output pane shows.
//
//   node smoke.mjs   (CHROME=/path/to/chrome to override the browser,
//                     SMOKE_URL=http://localhost:8080/play to test a server)

import { createServer } from "node:http";
import { readFile } from "node:fs/promises";
import { join, extname, dirname } from "node:path";
import { fileURLToPath } from "node:url";
import puppeteer from "puppeteer-core";

const here = dirname(fileURLToPath(import.meta.url));
const assetDir = join(here, "..", "asset");

// The playground's compiler version is set in playground/Makefile only.
const makefile = await readFile(join(here, "..", "Makefile"), "utf8");
const compiler = makefile.match(/^COMPILER=(\S+)$/m)[1];

const types = {
  ".html": "text/html",
  ".js": "text/javascript",
  ".cmi": "application/octet-stream",
};

const server = createServer(async (req, res) => {
  const path = decodeURIComponent(new URL(req.url, "http://x").pathname);
  const file =
    path === "/index.html" ? join(here, "index.html") : join(assetDir, path);
  if (path === "/favicon.ico") {
    res.writeHead(204).end();
    return;
  }
  if (path.includes("..")) {
    res.writeHead(400).end();
    return;
  }
  try {
    const body = await readFile(file);
    res.writeHead(200, {
      "Content-Type": types[extname(file)] ?? "application/octet-stream",
    });
    res.end(body);
  } catch {
    res.writeHead(404).end();
  }
});
await new Promise((resolve) => server.listen(0, "127.0.0.1", resolve));
// SMOKE_URL=http://localhost:8080/play runs the checks against a running
// server instead of the built assets.
const page_url =
  process.env.SMOKE_URL ??
  `http://127.0.0.1:${server.address().port}/index.html`;

const browser = await puppeteer.launch({
  executablePath: process.env.CHROME ?? "/usr/bin/google-chrome",
  args: ["--no-sandbox"],
});

const timeout = 30_000;
let failures = 0;

const outputText = (page) =>
  page.$eval("#output", (el) => el.textContent);

async function waitForOutput(page, needle) {
  await page.waitForFunction(
    (needle) => document.getElementById("output").textContent.includes(needle),
    { timeout },
    needle,
  );
}

async function open(code) {
  const page = await browser.newPage();
  page.on("pageerror", (e) => {
    console.error(`  page error: ${e.message}`);
    failures++;
  });
  if (process.env.SMOKE_CONSOLE)
    page.on("console", (m) => console.error(`  console.${m.type()}: ${m.text()}`));
  page.on("requestfailed", (r) =>
    console.error(`  request failed: ${r.url()}`),
  );
  page.on("response", (r) => {
    if (r.status() >= 400) console.error(`  HTTP ${r.status()}: ${r.url()}`);
  });
  await page.goto(`${page_url}#rawcode=${encodeURIComponent(code)}`);
  await waitForOutput(page, "OCaml version");
  return page;
}

async function check(name, f) {
  const t0 = Date.now();
  let page;
  try {
    page = await f((p) => (page = p));
    console.log(`ok   ${name} (${Date.now() - t0} ms)`);
  } catch (e) {
    failures++;
    console.log(`FAIL ${name}: ${e.message}`);
    if (page) console.log(`  output was:\n${await outputText(page)}`);
  } finally {
    if (page) await page.close();
  }
}

// Run the editor contents and wait for every expected string.
async function run(page, ...expected) {
  await page.click("#run");
  for (const needle of expected) await waitForOutput(page, needle);
}

await check("version", async (track) => {
  const page = track(await open("Sys.ocaml_version"));
  await run(page, `- : string = "${compiler}"`);
  return page;
});

await check("bindings, stdout and an effect handler", async (track) => {
  const page = track(
    await open(`type _ Effect.t += Ask : int Effect.t
let x = 41
let r =
  Effect.Deep.match_with
    (fun () -> Effect.perform Ask + 1)
    ()
    {
      Effect.Deep.retc = Fun.id;
      exnc = raise;
      effc =
        (fun (type a) (e : a Effect.t) ->
          match e with
          | Ask ->
              Some (fun (k : (a, _) Effect.Deep.continuation) ->
                  Effect.Deep.continue k x)
          | _ -> None);
    }
let () = print_endline "hello from stdout"`),
  );
  await run(page, "val x : int = 41", "val r : int = 42", "hello from stdout");
  return page;
});

await check("type error", async (track) => {
  const page = track(await open(`let y : int = "s"`));
  await run(page, "but an expression was expected of type");
  return page;
});

// Merlin runs in its own worker, on the editor contents, without running them.
await check("Merlin flags a type error in the editor", async (track) => {
  const page = track(await open(`let y : int = "s"`));
  await page.waitForSelector(".cm-lintRange-error", { timeout });
  return page;
});

await check("Merlin completes a stdlib name", async (track) => {
  const page = track(await open(""));
  await page.click(".cm-content");
  await page.keyboard.type("List.fil");
  await page.waitForFunction(
    () =>
      document
        .querySelector(".cm-tooltip-autocomplete")
        ?.textContent.includes("filter_map"),
    { timeout },
  );
  return page;
});

await check("uncaught exception", async (track) => {
  const page = track(await open(`let () = failwith "boom"`));
  await run(page, `Exception: Failure "boom".`);
  return page;
});

await check("stopping runaway code restarts the toplevel", async (track) => {
  const page = track(await open("let rec loop n = loop (n + 1) in loop 0"));
  await page.click("#run");
  await page.waitForFunction(
    () => document.getElementById("run-label").textContent === "STOP",
    { timeout },
  );
  await new Promise((r) => setTimeout(r, 1000));
  await page.click("#run");
  await waitForOutput(page, "Interrupted");
  await page.click(".cm-content");
  await page.keyboard.down("Control");
  await page.keyboard.press("a");
  await page.keyboard.up("Control");
  await page.keyboard.type("1 + 1");
  await run(page, "- : int = 2");
  return page;
});

await browser.close();
server.close();
console.log(failures === 0 ? "SMOKE PASSED" : `SMOKE FAILED (${failures})`);
process.exit(failures === 0 ? 0 : 1);
