"""A mock of the documentation backend, for scrape_test.sh.

    python3 mock_backend.py ROOT PORT_FILE

Serves ROOT/p/<pkg>/<version>/doc/sidebar.json over HTTP/1.1 (kept-alive
connections, as curl uses them): 200 with an ETag (the MD5 of the body) and a
Last-Modified (the file's mtime), 304 when If-None-Match matches, 404 when the
file does not exist. A file `<path>.status` next to a sidebar, or ROOT/status
for every request, holds a status code to answer instead (with an empty body).
Writes the port it listens on to PORT_FILE.
"""

import email.utils
import hashlib
import http.server
import os
import sys

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
        path = os.path.normpath(os.path.join(ROOT, self.path.lstrip("/")))
        if not path.startswith(os.path.abspath(ROOT) + os.sep):
            return self.reply(400)
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


server = http.server.ThreadingHTTPServer(("127.0.0.1", 0), Handler)
with open(sys.argv[2] + ".tmp", "w") as h:
    h.write(str(server.server_address[1]))
os.rename(sys.argv[2] + ".tmp", sys.argv[2])
server.serve_forever()
