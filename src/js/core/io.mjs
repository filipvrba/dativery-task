export default class IO {
  static p(contents) {
    return console.log(JSON.stringify(contents, null, 2))
  }
}