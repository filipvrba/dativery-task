import { create } from "xmlbuilder2";

export default class Xml {
  static generate(warehouses) {
    let root = create({version: "1.0", encoding: "utf-8"}).ele("SHOP");

    for (let warehouse of warehouses) {
      let item = root.ele("SHOPITEM");
      item.ele("ITEM_ID").txt(warehouse.cenik.replace("code:", ""));
      let stock = item.ele("STOCK").ele("WAREHOUSES").ele("WAREHOUSE");
      stock.ele("NAME").txt(warehouse.sklad.replace("code:", ""));
      stock.ele("VALUE").txt(warehouse.dostupMj)
    };

    return root.end({prettyPrint: true})
  }
}