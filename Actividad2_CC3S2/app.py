import os
import json
from datetime import datetime
from flask import Flask, jsonify, request

# 12-Factor: configuración por entorno
PORT = int(os.getenv("PORT", "8080"))
MESSAGE = os.getenv("MESSAGE", "Hola CC3S2")
RELEASE = os.getenv("RELEASE", "v0")

app = Flask(__name__)

def log_json(level, msg, extra=None):
    # Logs estructurados: JSON por línea a stdout (facilita parsing)
    payload = {
        "time": datetime.utcnow().isoformat() + "Z",
        "level": level,
        "message": msg,
        "release": RELEASE,
        "extra": extra or {}
    }
    print(json.dumps(payload), flush=True)

@app.route("/", methods=["GET"])
def index():
    log_json("INFO", "serving root", {"method": request.method, "path": "/"})
    return jsonify({
        "message": MESSAGE,
        "release": RELEASE,
        "path": "/",
        "method": request.method
    }), 200

# Example other route to demonstrate 405
@app.route("/", methods=["POST", "PUT", "DELETE"])
def not_allowed():
    # If you want POST to be not implemented: return 405
    log_json("WARN", "method not allowed on /", {"method": request.method})
    return jsonify({"error": "method not allowed"}), 405

if __name__ == "__main__":
    # Port binding: app must listen on env PORT
    log_json("INFO", f"starting app on 0.0.0.0:{PORT}", {})
    # Flask's built-in server is OK for lab; in prod usa gunicorn/uvicorn
    app.run(host="0.0.0.0", port=PORT)
