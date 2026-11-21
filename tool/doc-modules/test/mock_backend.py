"""A mock of the documentation backend, for scrape_test.sh.

    python3 mock_backend.py ROOT PORT_FILE

Serves ROOT/p/<pkg>/<version>/doc/sidebar.json over HTTP/1.1 (kept-alive
connections, as curl uses them): 200 with an ETag (the MD5 of the body) and a
Last-Modified (the file's mtime), 304 when If-None-Match matches, 404 when the
file does not exist. A file `<path>.status` next to a sidebar, or ROOT/status
for every request, holds a status code to answer instead (with an empty body).
A file `<path>.mode` holds a misbehaviour instead: `slow` (answer after 3
seconds), `truncated` (a Content-Length longer than the body, then close the
connection) or `garbled` (200 with a body that is not JSON). Every request path
is appended to ROOT/requests.log. Writes the port it listens on to PORT_FILE.
"""

import email.utils
import hashlib
import http.server
import os
import sys
import time

ROOT = os.path.abspath(sys.argv[1])


class Handler(http.server.BaseHTTPRequestHandler):
    protocol_version = "HTTP/1.1"

    def log_message(self, *args):
        pass

    def reply(self, code, body=b"", headers=()):
        self.send_response(code)
        for k, v in headers:
            self.send_header(k, v)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def forced_status(self, path):
        for f in (os.path.join(ROOT, "status"), path + ".status"):
            if os.path.isfile(f):
                with open(f) as h:
                    return int(h.read().strip())
        return None

    def do_GET(self):
        with open(os.path.join(ROOT, "requests.log"), "a") as h:
            h.write(self.path + "\n")
        path = os.path.normpath(os.path.join(ROOT, self.path.lstrip("/")))
        if not path.startswith(os.path.abspath(ROOT) + os.sep):
            return self.reply(400)
        mode = None
        if os.path.isfile(path + ".mode"):
            with open(path + ".mode") as h:
                mode = h.read().strip()
        if mode == "slow":
            time.sleep(3)
        elif mode == "garbled":
            return self.reply(200, b"<html>not json")
        elif mode == "truncated":
            self.send_response(200)
            self.send_header("Content-Length", "1000")
            self.end_headers()
            self.wfile.write(b'[{"node":')
            self.close_connection = True
            return
        status = self.forced_status(path)
        if status is not None:
            return self.reply(status)
        if not os.path.isfile(path):
            return self.reply(404)
        with open(path, "rb") as h:
            body = h.read()
        etag = '"%s"' % hashlib.md5(body).hexdigest()
        headers = [
            ("ETag", etag),
            ("Last-Modified",
             email.utils.formatdate(os.path.getmtime(path), usegmt=True)),
        ]
        if self.headers.get("If-None-Match") == etag:
            return self.reply(304, headers=headers)
        self.reply(200, body, headers + [("Content-Type", "application/json")])


class Server(http.server.ThreadingHTTPServer):
    # A client that gave up (`slow`) leaves a broken pipe: not worth a trace.
    def handle_error(self, request, client_address):
        pass


server = Server(("127.0.0.1", 0), Handler)
with open(sys.argv[2] + ".tmp", "w") as h:
    h.write(str(server.server_address[1]))
os.rename(sys.argv[2] + ".tmp", sys.argv[2])
server.serve_forever()
