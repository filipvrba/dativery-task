import path from "path";
import "./core/string.mjs";
import Files from "./core/files.mjs";
import IO from "./core/io.mjs";
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

async function main() {
  let warehouses = await stateWarehouses();

  // IO.p warehouses
  let xml = Xml.generateShoptet(warehouses);

  return Files.writeFile(
    {outputDirectory: OUTPUT_DIRECTORY, fileName: "shoptet_products.xml"},
    xml
  )
};

main().catch(console.error)