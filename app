from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse, parse_qs
from datetime import datetime

LOG_FILE = "/logs/web.log"

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        parsed = urlparse(self.path)
        params = parse_qs(parsed.query)

        if parsed.path == "/serv/" and "text" in params:
            text = params["text"][0]
            now = datetime.now().strftime("%a, %b %d, %Y %I:%M:%S %p")

            with open(LOG_FILE, "a") as f:
                f.write(f"{now} - {text}\n")

            self.send_response(200)
            self.end_headers()
            self.wfile.write(b"OK")
        else:
            self.send_response(404)
            self.end_headers()

server = HTTPServer(("0.0.0.0", 8080), Handler)
server.serve_forever()
