import 'fetch',    'node-fetch'
import ['create'], 'xmlbuilder2'
import 'fs',       'fs'
import 'path',     'path'

import '*', as: dotenv, from: 'dotenv'

dotenv.config()

ABRA_API_URL     = 'https://demo.flexibee.eu/c/demo/skladova-karta.json'
OUTPUT_DIRECTORY = path.join('.', 'shared')

async def fetch_stock_data(start, limit = 100)
  url = URL.new(ABRA_API_URL)
  url.search_params.append("limit", limit)
  url.search_params.append("start", start)
  url.search_params.append("detail", "custom:sklad,cenik,dostupMj,lastUpdate")
  url.search_params.append("add-row-count", "true")

  response = await fetch(url.to_s, {
    headers: {
        "Authorization": "Basic #{Buffer.from(process.env.ABRA_AUTH).to_s("base64")}",
        "Accept": "application/json"
    }
  })

  data = await response.json()
  [data.winstrom["skladova-karta"], data.winstrom["@rowCount"]]
end

def generateXML(products)
  root = create({ version: "1.0", encoding: "utf-8" })
        .ele("SHOP")

  products.each do |product|
    item = root.ele("SHOPITEM")
    item.ele("ITEM_ID").txt(product.cenik.sub('code:', ''))

    stock = item.ele("STOCK").ele("WAREHOUSES").ele("WAREHOUSE")
    stock.ele("NAME").txt(product.sklad.sub('code:', ''))
    stock.ele("VALUE").txt(product.dostup_mj)
  end

  root.end({ pretty_print: true })
end

async def main()
  all_products   = []
  start          = 0
  limit          = 100
  total_products = 100  # TODO: must change
  page           = 1

  while true
    products, _ = await fetch_stock_data(start, limit)

    break if products == undefined || products.length == 0

    all_products.push(*products)

    break if (start + limit) >= total_products

    puts "Načítám stránku #{page} z #{Math.ceil(total_products / limit)}"

    start = start + limit
    page += 1
  end

  xml = generateXML(all_products)
  
  await fs.promises.mkdir(OUTPUT_DIRECTORY, { recursive: true })
  file_path = path.join(OUTPUT_DIRECTORY, 'products.xml')

  fs.write_file(file_path, xml) do |err|
    if err
      console.error("Chyba při ukládání XML:", err)
    else
      puts "XML bylo úspěšně uloženo do složky #{OUTPUT_DIRECTORY}."
    end
  end
end


main().catch(console.error)
