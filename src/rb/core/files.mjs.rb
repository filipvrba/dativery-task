import 'fs',   'fs'
import 'path', 'path'

export default class Files

  async def self.write_file(options, content)
    await fs.promises.mkdir(options.output_directory, { recursive: true })
    file_path = path.join(options.output_directory, options.file_name)

    fs.write_file(file_path, content) do |err|
      if err
        console.error("Chyba při ukládání souboru:", err)
      else
        puts "Soubor '#{options.file_name}' bylo úspěšně uloženo do složky #{options.output_directory}."
      end
    end
  end
end