import path from "path";
import Files from "./core/files.mjs";
import Net from "./task/net.mjs";
import Xml from "./task/xml.mjs";
import IncrementalDataFetcher from "./task/abstracts/incremental_data_fetcher.mjs";
import * as dotenv from "dotenv";
const OUTPUT_DIRECTORY = path.join(".", "shared");
dotenv.config();

async function fetchWarehouses(options) {
  return await Net.fetchDataWarehouses(options)
};

async function stateWarehouses() {
  let fetcher = new IncrementalDataFetcher();
  return await fetcher.state(fetchWarehouses)
};

async function fetchProducts(options, refProducts) {
  return await Net.fetchDataProducts(options, refProducts)
};

async function stateProducts(refProducts) {
  let fetcher = new IncrementalDataFetcher(refProducts);
  return await fetcher.state(fetchProducts)
};

async function main() {
  let warehouses = await stateWarehouses();
  let refProducts = warehouses.map(h => h["cenik@ref"]);
  let products = await stateProducts(refProducts);
  return products
};

main().catch(console.error)