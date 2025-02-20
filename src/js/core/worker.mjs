import { parentPort, workerData } from "worker_threads";
import fetch from "node-fetch";

async function fetchData() {
  let url = workerData.url;
  console.log(workerData);

  let headers = {
    Authorization: `Basic ${Buffer.from(process.env.ABRA_AUTH).toString("base64")}`,
    Accept: "application/json"
  };

  try {
    let response = await fetch(url, headers);
    let data = await response.json();
    parentPort.postMessage(data)
  } catch (error) {
    parentPort.postMessage({error: error.message})
  }
};

fetchData()