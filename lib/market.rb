require "date"

class Market 
  attr_reader :name,
              :vendors,
              :date

  def initialize(name)
    @name = name 
    @vendors = []
    @date = Date.today.to_s
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map { |vendor| vendor.name }
  end

  def vendors_that_sell(item)
    @vendors.each_with_object([]) do |vendor, list|
       list << vendor if vendor.check_stock(item) != 0
    end
  end

  def total_inventory
    total_inventory = Hash.new{ |h, k| h[k] = {:quantity => 0, :vendors => []} }
    @vendors.each do |vendor|
      vendor.inventory.each do |item, quantity|
        total_inventory[item][:quantity] += quantity
        total_inventory[item][:vendors] << vendor
      end
    end
    total_inventory
  end

  def overstocked_items
    items = total_inventory.select { |item, info| info[:quantity] > 50 && info[:vendors].length > 1 }
    items.keys
  end

  def sorted_item_list
    items = total_inventory.keys 
    items.map { |item| item.name }.sort
  end

  def sell(item, quantity)
    if !total_inventory.keys.include?(item) || total_inventory[item][:quantity] < quantity
      false
    else 
      total_inventory[item][:vendors].each do |vendor|
        until vendor.inventory[item] == 0 || quantity == 0
          vendor.inventory[item] -= 1 
          quantity -= 1
        end
        quantity > 0 ? next : break
      end
      true 
    end
  end
end