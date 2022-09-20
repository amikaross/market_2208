class Market 
  attr_reader :name,
              :vendors

  def initialize(name)
    @name = name 
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map { |vendor| vendor.name }
  end

  def vendors_that_sell(item)
    @vendors.each_with_object([]) do |vendor, list|
      vendor.check_stock(item) != 0 ? list << vendor : next 
    end
  end
end