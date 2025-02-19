import fs from "fs";
import path from "path";

export default class Files {
  static async writeFile(options, content) {
    await fs.promises.mkdir(options.outputDirectory, {recursive: true});
    let filePath = path.join(options.outputDirectory, options.fileName);

    return fs.writeFile(filePath, content, err => (
      err ? console.error("Chyba při ukládání souboru:", err) : console.log(`Soubor '${options.fileName}' bylo úspěšně uloženo do složky ${options.outputDirectory}.`)
    ))
  }
}