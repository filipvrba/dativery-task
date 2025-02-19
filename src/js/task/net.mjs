import fetch from "node-fetch";

export default class Net {
  static async fetchDataWarehouses(options) {
    let url = new URL(Net.WAREHOUSE_CARD_API_URL);
    url.searchParams.append("limit", options.limit);
    url.searchParams.append("start", options.start);

    url.searchParams.append(
      "detail",
      "custom:sklad,cenik,dostupMj,lastUpdate"
    );

    url.searchParams.append("add-row-count", "true");

    let response = await fetch(url.toString(), {headers: {
      Authorization: `Basic ${Buffer.from(process.env.ABRA_AUTH).toString("base64")}`,
      Accept: "application/json"
    }});

    let data = await response.json();
    let warehouses = data.winstrom["skladova-karta"];
    let rowCount = data.winstrom["@rowCount"];
    return [warehouses, rowCount]
  };

  static async fetchDataProducts(options, refProducts) {
    console.log(refProducts);
    return [undefined, undefined]
  }
};

Net.WAREHOUSE_CARD_API_URL = "https://demo.flexibee.eu/c/demo/skladova-karta.json"