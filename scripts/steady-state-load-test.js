import { sleep, check } from "k6";
import http from "k6/http";

export const options = {
    ext: {
    loadimpact: {
        distribution: {
        "amazon:us:ashburn": { loadZone: "amazon:us:ashburn", percent: 100 },
        },
    },
    },
    stages: [
    { target: 10, duration: "10s" },
    { target: 10, duration: "29m40s" },
    { target: 0, duration: "10s" },
    ],
    thresholds: {},
};

export default function main() {
    let response;

    // Greeting
    response = http.get("$TAP_CNR_URL");
    check(response, {
    "status equals 200": response => response.status.toString() === "200",
    });
    sleep(1);
}