export default class IncrementalDataFetcher {
  get limit() {
    return this._limit
  };

  constructor(options=null, limit=100) {
    this._options = options;
    this._limit = limit
  };

  async state(callback) {
    if (typeof callback !== "function") {
      throw(new Error("Callback must be a function"))
    };

    this._isRunning = true;
    let allResults = [];
    let start = 0;
    let totalResults = 100;
    let page = 1;

    while (this._isRunning) {
      let [result, _] = await callback(
        {start, limit: this._limit},
        this._options
      );

      if (result === undefined) break;
      allResults.push(...result);
      if ((start + this._limit) >= totalResults) break;
      console.log(`Načítám stránku ${page} z ${Math.ceil(totalResults / this._limit)}`);
      start = start + this._limit;
      page++
    };

    return allResults
  };

  stop() {
    this._isRunning = false;
    return this._isRunning
  }
}