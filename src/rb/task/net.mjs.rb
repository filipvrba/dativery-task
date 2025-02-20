import 'fetch', 'node-fetch'

export default class Net

  ABRA_FLEXI_API_URL = 'https://demo.flexibee.eu'

  async def self.fetchJSON(url)
    begin
      headers = {
        "Authorization": "Basic #{Buffer.from(process.env.ABRA_AUTH).to_s("base64")}",
        "Accept": "application/json"
      }

      response = await fetch(url, { headers: headers })
      return await response.json()
    rescue => error
      console.error("Chyba při načítání dat:", error)
      return nil
    end
  end

  async def self.fetch_data_warehouses(options)
    url = URL.new(ABRA_FLEXI_API_URL + "/c/demo/skladova-karta.json")
    url.search_params.append("limit", options.limit)
    url.search_params.append("start", options.start)
    url.search_params.append("detail", "custom:sklad,cenik,dostupMj,lastUpdate")
    url.search_params.append("add-row-count", "true")

    data = await Net.fetchJSON(url)

    warehouses = data.winstrom["skladova-karta"] 
    row_count  = data.winstrom["@rowCount"]

    await Net.enrich_with_data(warehouses)

    [warehouses, row_count]
  end


  async def self.enrich_with_data(warehouses)
    requests = []

    warehouses.each do |warehouse|
      if warehouse["cenik@ref"]
        requests.push(Net.enrich_warehouse('cenik@ref', warehouse))
      end
    end

    await Promise.all_settled(requests)
  end

  async def self.enrich_warehouse(key, warehouse)
    url = ABRA_FLEXI_API_URL + warehouse[key]
    fetch_data = await Net.fetchJSON(url)
    warehouse[key.sub('@ref', '@data')] = fetch_data.winstrom
  end
end