import ['create'], 'xmlbuilder2'

export default class Xml

  def self.generate(warehouses)
    root = create({ version: "1.0", encoding: "utf-8" })
          .ele("SHOP")

    warehouses.each do |warehouse|
      item = root.ele("SHOPITEM")
      item.ele("ITEM_ID").txt(warehouse.cenik.sub('code:', ''))

      stock = item.ele("STOCK").ele("WAREHOUSES").ele("WAREHOUSE")
      stock.ele("NAME").txt(warehouse.sklad.sub('code:', ''))
      stock.ele("VALUE").txt(warehouse.dostup_mj)
    end

    root.end({ pretty_print: true })
  end

  def self.generate_shoptet(warehouses)
    root = create({ version: "1.0", encoding: "utf-8" }).ele("SHOP")

    warehouses.each do |warehouse|
      cenik_data = warehouse["cenik@data"]
      next unless cenik_data

      products_data = cenik_data[cenik]
      next unless products_data

      product_data = products_data.first
      next unless product_data

      item = root.ele("SHOPITEM")
      # item.ele("ITEM_ID").txt(warehouse.cenik.sub('code:', ''))

      # Základní informace o produktu
      item.ele("NAME").txt(product_data.nazev);
      item.ele("SHORT_DESCRIPTION").txt(product_data.popisKr || "N/A")
      item.ele("DESCRIPTION").txt(product_data.popis || "N/A")
      item.ele("MANUFACTURER").txt(product_data.vyrobce.sub('code:', '') || "N/A")
      item.ele("SUPPLIER").txt(product_data.dodavatel.sub('code:', '') || "N/A")
      item.ele("WARRANTY").txt(product_data.zaruka || "24")
      item.ele("ITEM_TYPE").txt("product")
      item.ele("CODE").txt(product_data.kod, "N/A")
      item.ele("EAN").txt(product_data.eanKod || "N/A")

      # Kategorie
      value_category = product_data.skup_zboz.sub('code:', '')
      if value_category
        categories = item.ele("CATEGORIES")
        categories.ele("CATEGORY").txt(value_category)
      end

      # Obrázky
      images = item.ele("IMAGES")

      # Parametry
      params = item.ele("INFORMATION_PARAMETERS")

      # Skladová dostupnost
      stock = item.ele("STOCK").ele("WAREHOUSES").ele("WAREHOUSE")
      stock.ele("NAME").txt(warehouse.sklad.sub('code:', ''))
      stock.ele("VALUE").txt(warehouse.dostup_mj.format_stock_value())

      # Cena
      item.ele("CURRENCY").txt("CZK");
      item.ele("PRICE").txt(productData.cena_zakl_bez_dph.format_price())
      item.ele("STANDARD_PRICE").txt(productData.cena_zakl_vc_dph.format_price())
      item.ele("PURCHASE_PRICE").txt(productData.nakup_cena.format_price())

      # Flags (např. novinka, akce)
      flags = item.ele("FLAGS")

      # Logistika (hmotnost, rozměry)
      logistics = item.ele("LOGISTIC")
      logistics.ele("WEIGHT").txt(productData.hmotnost || "0")
      logistics.ele("HEIGHT").txt(productData.vyska || "0")
      logistics.ele("WIDTH").txt(productData.sirka || "0")
      logistics.ele("DEPTH").txt(productData.hloubka || "0")

      # SEO
      item.ele("SEO_TITLE").txt(productData.seoTitulek || "N/A")
      item.ele("META_DESCRIPTION").txt(productData.seoPopis || "N/A")

      # Viditelnost
      item.ele("VISIBILITY").txt("visible")
      item.ele("VISIBLE").txt("1")
    end

    return root.end({ prettyPrint: true })
  end
end