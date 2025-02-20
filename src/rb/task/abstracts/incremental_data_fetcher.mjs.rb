export default class IncrementalDataFetcher
  attr_reader :limit

  def initialize(options = nil, limit = 100)
    @options = options 
    @limit   = limit
  end

  async def state(&callback)
    if typeof callback != "function"
      throw new Error("Callback must be a function")
    end

    @is_running   = true
    all_results   = []
    start         = 0
    total_results = 100
    page          = 1

    while @is_running
      result, total_results = await callback({start: start, limit: @limit}, @options)

      break if result == undefined

      all_results.push(*result)
  
      break if (start + @limit) >= total_results
  
      puts "Načítám stránku #{page} z #{Math.ceil(total_results / @limit)}"
  
      start = start + @limit
      page += 1
    end

    all_results
  end

  def stop()
    @is_running = false
  end
end