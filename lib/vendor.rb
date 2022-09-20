class Vendor 
  attr_reader :name,
              :inventory

  def initialize(name)
    @name = name 
    @inventory = Hash.new(0)
  end

  def check_stock(item)
    @inventory.keys.include?(item) ? @inventory[item] : 0
  end

  def stock(item, quantity)
    @inventory[item] += quantity
  end

  def potential_revenue
    sum = 0
    @inventory.each do |item, quantity|
      sum += item.price * quantity
    end
    sum
  end
end