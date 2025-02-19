import 'fetch', 'node-fetch'

export default class Net

  WAREHOUSE_CARD_API_URL = 'https://demo.flexibee.eu/c/demo/skladova-karta.json'

  async def self.fetch_data_warehouses(options)
    url = URL.new(WAREHOUSE_CARD_API_URL)
    url.search_params.append("limit", options.limit)
    url.search_params.append("start", options.start)
    url.search_params.append("detail", "custom:sklad,cenik,dostupMj,lastUpdate")
    url.search_params.append("add-row-count", "true")

    response = await fetch(url.to_s, {
      headers: {
          "Authorization": "Basic #{Buffer.from(process.env.ABRA_AUTH).to_s("base64")}",
          "Accept": "application/json"
      }
    })

    data       = await response.json()
    warehouses = data.winstrom["skladova-karta"] 
    row_count  = data.winstrom["@rowCount"]

    [warehouses, row_count]
  end

  async def self.fetch_data_products(options, ref_products)
    puts ref_products
    # url = URL.new(WAREHOUSE_CARD_API_URL)
    # url.search_params.append("limit", limit)
    # url.search_params.append("start", start)
    # url.search_params.append("detail", "custom:sklad,cenik,dostupMj,lastUpdate")
    # url.search_params.append("add-row-count", "true")

    # response = await fetch(url.to_s, {
    #   headers: {
    #       "Authorization": "Basic #{Buffer.from(process.env.ABRA_AUTH).to_s("base64")}",
    #       "Accept": "application/json"
    #   }
    # })

    # data       = await response.json()
    # warehouses = data.winstrom["skladova-karta"] 
    # row_count  = data.winstrom["@rowCount"]

    # [warehouses, row_count]
    [undefined, undefined]
  end
end