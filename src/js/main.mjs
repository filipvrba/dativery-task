import fetch from "node-fetch";
import { create } from "xmlbuilder2";
import fs from "fs";
import path from "path";
import * as dotenv from "dotenv";
dotenv.config();
const ABRA_API_URL = "https://demo.flexibee.eu/c/demo/skladova-karta.json";
const OUTPUT_DIRECTORY = path.join(".", "shared");

async function fetchStockData(start, limit=100) {
  let url = new URL(ABRA_API_URL);
  url.searchParams.append("limit", limit);
  url.searchParams.append("start", start);

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
  return [data.winstrom["skladova-karta"], data.winstrom["@rowCount"]]
};

function generateXML(products) {
  let root = create({version: "1.0", encoding: "utf-8"}).ele("SHOP");

  for (let product of products) {
    let item = root.ele("SHOPITEM");
    item.ele("ITEM_ID").txt(product.cenik.replace("code:", ""));
    let stock = item.ele("STOCK").ele("WAREHOUSES").ele("WAREHOUSE");
    stock.ele("NAME").txt(product.sklad.replace("code:", ""));
    stock.ele("VALUE").txt(product.dostupMj)
  };

  return root.end({prettyPrint: true})
};

async function main() {
  let allProducts = [];
  let start = 0;
  let limit = 100;
  let totalProducts = 100;
  let page = 1;

  while (true) {
    let products;
    [products, totalProducts] = await fetchStockData(start, limit);
    if (products === undefined || products.length === 0) break;
    allProducts.push(...products);
    if ((start + limit) >= totalProducts) break;
    console.log(`Načítám stránku ${page} z ${Math.ceil(totalProducts / limit)}`);
    start = start + limit;
    page++
  };

  let xml = generateXML(allProducts);
  await fs.promises.mkdir(OUTPUT_DIRECTORY, {recursive: true});
  let filePath = path.join(OUTPUT_DIRECTORY, "products.xml");

  return fs.writeFile(filePath, xml, err => (
    err ? console.error("Chyba při ukládání XML:", err) : console.log(`XML bylo úspěšně uloženo do složky ${OUTPUT_DIRECTORY}.`)
  ))
};

main().catch(console.error)