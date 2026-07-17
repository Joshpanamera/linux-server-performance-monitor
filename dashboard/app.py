from flask import Flask, render_template, jsonify
import json

app = Flask(__name__)

METRICS_FILE = "sample-metrics.json"


def cpu_status(cpu):
    cpu = float(cpu)

    if cpu < 50:
        return "Healthy", "green"
    elif cpu < 80:
        return "Warning", "orange"
    else:
        return "Critical", "red"


def server_health(cpu):
    cpu = float(cpu)

    if cpu < 50:
        return "🟢 ONLINE"
    elif cpu < 80:
        return "🟡 UNDER LOAD"
    else:
        return "🔴 CRITICAL"


@app.route("/")
def home():

    with open(METRICS_FILE) as f:
        metrics = json.load(f)

    status, colour = cpu_status(metrics["cpu_usage"])
    health = server_health(metrics["cpu_usage"])

    return render_template(
        "index.html",
        metrics=metrics,
        cpu_status=status,
        cpu_colour=colour,
        health=health
    )


@app.route("/api/metrics")
def metrics():

    with open(METRICS_FILE) as f:
        data = json.load(f)

    return jsonify(data)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
