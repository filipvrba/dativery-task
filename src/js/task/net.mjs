import fetch from "node-fetch";

export default class Net {
  static async fetchJSON(url) {
    try {
      let headers = {
        Authorization: `Basic ${Buffer.from(process.env.ABRA_AUTH).toString("base64")}`,
        Accept: "application/json"
      };

      let response = await fetch(url, {headers});
      return await response.json()
    } catch (error) {
      console.error("Chyba při načítání dat:", error);
      return null
    }
  };

  static async fetchDataWarehouses(options) {
    let url = new URL(Net.ABRA_FLEXI_API_URL + "/c/demo/skladova-karta.json");
    url.searchParams.append("limit", options.limit);
    url.searchParams.append("start", options.start);

    url.searchParams.append(
      "detail",
      "custom:sklad,cenik,dostupMj,lastUpdate"
    );

    url.searchParams.append("add-row-count", "true");
    let data = await Net.fetchJSON(url);
    let warehouses = data.winstrom["skladova-karta"];
    let rowCount = data.winstrom["@rowCount"];
    await Net.enrichWithData(warehouses);
    return [warehouses, rowCount]
  };

  static async enrichWithData(warehouses) {
    let requests = [];

    for (let warehouse of warehouses) {
      if (warehouse["cenik@ref"]) {
        requests.push(Net.enrichWarehouse("cenik@ref", warehouse))
      }
    };

    return await Promise.allSettled(requests)
  };

  static async enrichWarehouse(key, warehouse) {
    let url = Net.ABRA_FLEXI_API_URL + warehouse[key];
    let fetchData = await Net.fetchJSON(url);
    return warehouse[key.replace("@ref", "@data")] = fetchData.winstrom
  }
};

Net.ABRA_FLEXI_API_URL = "https://demo.flexibee.eu"