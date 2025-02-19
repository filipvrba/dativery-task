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
end