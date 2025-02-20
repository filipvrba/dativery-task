
def format_price()
  number = parse_float(self)
  
  if self.sub('.', "").length > 12
    number = number / 100
  end

  number <= 0.to_f ? 0.to_f.to_fixed(2) : number.to_fixed(2)
end
String.prototype.format_price = format_price

def format_stock_value()
  number = self.to_f
  number <= 0.to_f ? 0.to_f.to_fixed(3) : number.to_fixed(3)
end
String.prototype.format_stock_value = format_stock_value
