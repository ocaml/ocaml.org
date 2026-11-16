// Smoke test of the built playground: serve playground/asset/ with the
// harness page, drive it in headless Chrome, check what the output pane shows.
//
//   node smoke.mjs   (CHROME=/path/to/chrome to override the browser,
//                     SMOKE_URL=http://localhost:8080/play to test a server,
//                     SMOKE_CONSOLE=1 to print the pages' console)
//
// A check fails if an expected output does not appear, or if the page or one
// of its workers logs an error or throws.

import { createServer } from "node:http";
import { readFile } from "node:fs/promises";
import { join, extname, dirname } from "node:path";
import { fileURLToPath } from "node:url";
import puppeteer from "puppeteer-core";

const here = dirname(fileURLToPath(import.meta.url));
const playground = join(here, "..");
const assetDir = join(playground, "asset");
const template = join(
  playground,
  "..",
  "src",
  "ocamlorg_frontend",
  "pages",
  "playground.eml",
);

// The playground's compiler version is set in playground/Makefile only.
const makefile = await readFile(join(playground, "Makefile"), "utf8");
const compiler = makefile.match(/^COMPILER=(\S+)$/m)[1];

// ~~~ Static server for the harness page and the built assets ~~~

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
const page_url =
  process.env.SMOKE_URL ??
  `http://127.0.0.1:${server.address().port}/index.html`;

const browser = await puppeteer.launch({
  executablePath: process.env.CHROME ?? "/usr/bin/google-chrome",
  args: ["--no-sandbox"],
});

const timeout = 30_000;
let failures = 0;

// ~~~ Helpers ~~~

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

function assert(condition, message) {
  if (!condition) throw new Error(message);
}

const outputText = (page) => page.$eval("#output", (el) => el.textContent);

// The output pane's chunks, in order, with their colour.
const outputSpans = (page) =>
  page.$$eval("#output span", (spans) =>
    spans.map((s) => ({ text: s.textContent, color: s.style.color })),
  );

async function waitForOutput(page, needle) {
  await page.waitForFunction(
    (needle) => document.getElementById("output").textContent.includes(needle),
    { timeout },
    needle,
  );
}

// Each page records its errors in [page.problems]; [check] fails on any.
async function open(code) {
  const page = await browser.newPage();
  page.problems = [];
  const problem = (what) => {
    page.problems.push(what);
    console.error(`  ${what}`);
  };
  // Puppeteer also reports uncaught exceptions in the page's workers here.
  page.on("pageerror", (e) => problem(`page error: ${e.message}`));
  page.on("console", (m) => {
    if (process.env.SMOKE_CONSOLE)
      console.error(`  console.${m.type()}: ${m.text()}`);
    if (m.type() === "error") problem(`console error: ${m.text()}`);
  });
  page.on("requestfailed", (r) => {
    // A worker killed by Stop cancels its own pending requests.
    if (r.failure()?.errorText !== "net::ERR_ABORTED")
      problem(`request failed: ${r.url()}`);
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
    if (page) assert(page.problems.length === 0, "errors logged (see above)");
    console.log(`ok   ${name} (${Date.now() - t0} ms)`);
  } catch (e) {
    failures++;
    console.log(`FAIL ${name}: ${e.message}`);
    if (page && !page.isClosed())
      console.log(`  output was:\n${await outputText(page)}`);
  } finally {
    if (page && !page.isClosed()) await page.close();
  }
}

// Replace the editor contents. Inserted as one input, so CodeMirror does not
// auto-close brackets or offer completions on the way.
async function setEditor(page, code) {
  await page.click(".cm-content");
  await page.keyboard.down("Control");
  await page.keyboard.press("a");
  await page.keyboard.up("Control");
  await page.keyboard.sendCharacter(code);
  const text = await editorText(page);
  assert(text === code, `editor holds ${JSON.stringify(text)}`);
}

const editorText = (page) =>
  page.$$eval(".cm-content .cm-line", (lines) =>
    lines.map((l) => l.textContent).join("\n"),
  );

// Run the editor contents and wait for every expected string.
async function run(page, ...expected) {
  await page.click("#run");
  for (const needle of expected) await waitForOutput(page, needle);
}

async function stop(page) {
  await page.waitForFunction(
    () => document.getElementById("run-label").textContent === "STOP",
    { timeout },
  );
  await sleep(1000);
  await page.click("#run");
  await waitForOutput(page, "Interrupted");
}

// The middle of the first occurrence of [word] in the editor, on screen.
const positionOf = (page, word) =>
  page.evaluate((word) => {
    const content = document.querySelector(".cm-content");
    const walker = document.createTreeWalker(content, NodeFilter.SHOW_TEXT);
    for (let n = walker.nextNode(); n; n = walker.nextNode()) {
      const i = n.textContent.indexOf(word);
      if (i < 0) continue;
      const range = document.createRange();
      range.setStart(n, i);
      range.setEnd(n, i + word.length);
      const r = range.getBoundingClientRect();
      return { x: r.left + r.width / 2, y: r.top + r.height / 2 };
    }
    return null;
  }, word);

// ~~~ Checks ~~~

// The harness page stands in for the real template in CI: both must provide
// every element and data attribute that the playground's OCaml code looks up.
await check("harness and template provide what main.ml uses", async () => {
  const sources = await Promise.all(
    ["main.ml", "edit.ml"].map((f) =>
      readFile(join(playground, "src", f), "utf8"),
    ),
  );
  const ids = new Set();
  const attributes = new Set();
  for (const source of sources) {
    for (const [, id] of source.matchAll(/get_el_by_id "([^"]+)"/g))
      ids.add(id);
    for (const [, a] of source.matchAll(/get_script_data "([^"]+)"/g))
      attributes.add(a);
  }
  assert(ids.size > 0 && attributes.size > 0, "found no lookups in src/");
  for (const [name, file] of [
    ["harness", join(here, "index.html")],
    ["template", template],
  ]) {
    const html = await readFile(file, "utf8");
    for (const id of ids)
      assert(html.includes(`id="${id}"`), `${name} has no id="${id}"`);
    for (const a of attributes)
      assert(html.includes(`${a}=`), `${name} has no ${a} attribute`);
  }
});

await check("version", async (track) => {
  const page = track(await open("Sys.ocaml_version"));
  await run(page, `- : string = "${compiler}"`);
  return page;
});

await check("an effect handler", async (track) => {
  const page = track(
    await open(`type _ Effect.t += Ask : int Effect.t
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
                  Effect.Deep.continue k 41)
          | _ -> None);
    }`),
  );
  await run(page, "val r : int = 42");
  return page;
});

await check("type error", async (track) => {
  const page = track(await open(`let y : int = "s"`));
  await run(page, "but an expression was expected of type");
  return page;
});

await check("uncaught exception", async (track) => {
  const page = track(await open(`let () = failwith "boom"`));
  await run(page, `Exception: Failure "boom".`);
  return page;
});

// One page, several runs: what a user does.
await check(
  "a session: state, output streams, warnings, Stop",
  async (track) => {
    const page = track(await open("let x = 41"));
    await run(page, "val x : int = 41");

    // Definitions persist across runs; stdout, stderr, answers and warnings are
    // told apart by colour.
    await setEditor(
      page,
      `let () = print_endline "to stdout"
let () = prerr_endline "to stderr"
let y = x + 1
let f = function 0 -> 1`,
    );
    await run(page, "val y : int = 42", "Warning 8", "val f : int -> int");
    const spans = await outputSpans(page);
    const find = (needle) => spans.findIndex((s) => s.text.includes(needle));
    const color = (needle) => spans[find(needle)]?.color;
    assert(color("to stdout") === "cyan", `stdout is ${color("to stdout")}`);
    assert(color("to stderr") === "red", `stderr is ${color("to stderr")}`);
    assert(color("val y") === "white", `answers are ${color("val y")}`);
    assert(
      color("Warning 8") === "yellow",
      `warnings are ${color("Warning 8")}`,
    );
    assert(find("to stdout") < find("val y"), "stdout came after the answer");

    // Stop restarts the toplevel: the banner is printed again, and earlier
    // definitions are gone.
    await setEditor(page, "let rec loop n = loop (n + 1) in loop 0");
    await page.click("#run");
    await stop(page);
    const banners = (await outputText(page)).split("OCaml version").length - 1;
    assert(banners === 2, `${banners} banners after Stop, expected 2`);
    await setEditor(page, "x");
    await run(page, "Unbound value x");
    await setEditor(page, "1 + 1");
    await run(page, "- : int = 2");
    return page;
  },
);

await check("Share puts the code in the URL", async (track) => {
  const code = `let shared = "café"`;
  const page = track(await open(""));
  await setEditor(page, code);
  await page.click("#share");
  await page.waitForFunction(() => location.hash.startsWith("#code="), {
    timeout,
  });
  await page.reload();
  await waitForOutput(page, "OCaml version");
  const text = await editorText(page);
  assert(text === code, `after reload, editor holds ${JSON.stringify(text)}`);
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

await check("Merlin shows a type on hover", async (track) => {
  const page = track(await open("let n = List.length [ 1; 2 ]"));
  const at = await positionOf(page, "length");
  assert(at, "could not find the identifier in the editor");
  // Merlin may still be loading the stdlib: move away and back until the
  // tooltip shows.
  const deadline = Date.now() + timeout;
  for (;;) {
    await page.mouse.move(at.x, at.y);
    const shown = await page
      .waitForFunction(
        () =>
          document
            .querySelector(".cm-tooltip-hover")
            ?.textContent.includes("list -> int"),
        { timeout: 2000 },
      )
      .then(() => true)
      .catch(() => false);
    if (shown) break;
    assert(Date.now() < deadline, "no type shown on hover");
    await page.mouse.move(0, 0);
  }
  return page;
});

await browser.close();
server.close();
console.log(failures === 0 ? "SMOKE PASSED" : `SMOKE FAILED (${failures})`);
process.exit(failures === 0 ? 0 : 1);
