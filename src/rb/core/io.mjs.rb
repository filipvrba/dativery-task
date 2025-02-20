export default class IO
  def self.p(contents)
    puts JSON.stringify(contents, null, 2)
  end
end