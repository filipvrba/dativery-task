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
  };

  static generateShoptet(warehouses) {
    let root = create({version: "1.0", encoding: "utf-8"}).ele("SHOP");

    for (let warehouse of warehouses) {
      let cenikData = warehouse["cenik@data"];
      if (!cenikData) continue;
      let productsData = cenikData.cenik;
      if (!productsData) continue;
      let productData = productsData[0];
      if (!productData) continue;
      let item = root.ele("SHOPITEM");

      // item.ele("ITEM_ID").txt(warehouse.cenik.sub('code:', ''))
      // Základní informace o produktu
      item.ele("NAME").txt(productData.nazev);
      item.ele("SHORT_DESCRIPTION").txt(productData.popisKr || "N/A");
      item.ele("DESCRIPTION").txt(productData.popis || "N/A");
      item.ele("MANUFACTURER").txt(productData.vyrobce.replace("code:", "") || "N/A");
      item.ele("SUPPLIER").txt(productData.dodavatel.replace("code:", "") || "N/A");
      item.ele("WARRANTY").txt(productData.zaruka || "24");
      item.ele("ITEM_TYPE").txt("product");
      item.ele("CODE").txt(productData.kod, "N/A");
      item.ele("EAN").txt(productData.eanKod || "N/A");

      // Kategorie
      let valueCategory = productData.skupZboz.replace("code:", "");

      if (valueCategory) {
        let categories = item.ele("CATEGORIES");
        categories.ele("CATEGORY").txt(valueCategory)
      };

      // Obrázky
      let images = item.ele("IMAGES");

      // Parametry
      let params = item.ele("INFORMATION_PARAMETERS");

      // Skladová dostupnost
      let stock = item.ele("STOCK").ele("WAREHOUSES").ele("WAREHOUSE");
      stock.ele("NAME").txt(warehouse.sklad.replace("code:", ""));
      stock.ele("VALUE").txt(warehouse.dostupMj.formatStockValue());

      // Cena
      item.ele("CURRENCY").txt("CZK");
      item.ele("PRICE").txt(productData.cenaZaklBezDph.formatPrice());
      item.ele("STANDARD_PRICE").txt(productData.cenaZaklVcDph.formatPrice());
      item.ele("PURCHASE_PRICE").txt(productData.nakupCena.formatPrice());

      // Flags (např. novinka, akce)
      let flags = item.ele("FLAGS");

      // Logistika (hmotnost, rozměry)
      let logistics = item.ele("LOGISTIC");
      logistics.ele("WEIGHT").txt(productData.hmotnost || "0");
      logistics.ele("HEIGHT").txt(productData.vyska || "0");
      logistics.ele("WIDTH").txt(productData.sirka || "0");
      logistics.ele("DEPTH").txt(productData.hloubka || "0");

      // SEO
      item.ele("SEO_TITLE").txt(productData.seoTitulek || "N/A");
      item.ele("META_DESCRIPTION").txt(productData.seoPopis || "N/A");

      // Viditelnost
      item.ele("VISIBILITY").txt("visible");
      item.ele("VISIBLE").txt("1")
    };

    return root.end({prettyPrint: true})
  }
}