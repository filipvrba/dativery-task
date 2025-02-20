import 'path',  'path'

import './core/string.mjs'
import 'Files', './core/files.mjs'
import 'IO',    './core/io.mjs'
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

async def main()
  warehouses = await state_warehouses()
  # IO.p warehouses

  xml = Xml.generate_shoptet(warehouses)
  Files.write_file({output_directory: OUTPUT_DIRECTORY, file_name: 'shoptet_products.xml'}, xml)
end


main().catch(console.error)
