import 'path',  'path'

import 'Files', './core/files.mjs'
import 'Net',   './task/net.mjs'
import 'Xml',   './task/xml.mjs'

import 'IncrementalDataFetcher', './task/abstracts/incremental_data_fetcher.mjs'

import '*', as: dotenv, from: 'dotenv'


OUTPUT_DIRECTORY = path.join('.', 'shared')

dotenv.config()


async def fetch_warehouses(options)
  await Net.fetch_data_warehouses(options)
end

async def state_warehouses()
  fetcher = IncrementalDataFetcher.new()
  await fetcher.state(fetch_warehouses)
end

async def fetch_products(options, ref_products)
  await Net.fetch_data_products(options, ref_products)
end

async def state_products(ref_products)
  fetcher = IncrementalDataFetcher.new(ref_products)
  await fetcher.state(fetch_products)
end

async def main()
  warehouses   = await state_warehouses()
  ref_products = warehouses.map {|h| h['cenik@ref']}
  products     = await state_products(ref_products)

  # xml = Xml.generate(warehouses)
  # Files.write_file({output_directory: OUTPUT_DIRECTORY, file_name: 'products.xml'}, xml)
end


main().catch(console.error)
