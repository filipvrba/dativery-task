function formatPrice() {
  let number = parseFloat(this);
  if (this.replace(".", "").length > 12) number = number / 100;
  return number <= parseFloat(0) ? parseFloat(0).toFixed(2) : number.toFixed(2)
};

String.prototype.formatPrice = formatPrice;

function formatStockValue() {
  let number = parseFloat(this);
  return number <= parseFloat(0) ? parseFloat(0).toFixed(3) : number.toFixed(3)
};

String.prototype.formatStockValue = formatStockValue