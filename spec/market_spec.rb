require "rspec"
require "./lib/item"
require "./lib/vendor"
require "./lib/market"

RSpec.describe Market do 
  before(:each) do 
    @item1 = Item.new({name: "Peach", price: "$0.75"})
    @item2 = Item.new({name: "Tomato", price: "$0.50"})
    @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
    @vendor1 = Vendor.new("Rocky Mountain Fresh")
    @vendor2 = Vendor.new("Ba-Nom-a-Nom")
    @vendor3 = Vendor.new("Palisade Peach Shack")
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
    @vendor3.stock(@item3, 10)
    @market = Market.new("South Pearl Street Farmers Market")
  end

  describe "#initialize" do 
    it "exists" do 
      expect(@market).to be_an_instance_of(Market)
    end

    it "has a readable name" do 
      expect(@market.name).to eq("South Pearl Street Farmers Market")
    end

    it "starts out with no vendors" do 
      expect(@market.vendors).to eq([])
    end

    it "has a date" do 
      expect(@market.date).to eq("2022-09-20")
    end
  end 

  describe "#add_vendor" do 
    it "adds a given vendor to the markets list of vendors" do 
      @market.add_vendor(@vendor1)
      expect(@market.vendors).to eq([@vendor1])
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
      expect(@market.vendors).to eq([@vendor1, @vendor2, @vendor3])
    end
  end

  describe "#vendor_names" do 
    it "lists all the names of all vendors at the market" do 
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
      expect(@market.vendor_names).to eq(["Rocky Mountain Fresh", "Ba-Nom-a-Nom", "Palisade Peach Shack"])
    end
  end

  describe "#vendors_that_sell" do 
    it "returns a list of vendors that sell a given item" do 
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
      expect(@market.vendors_that_sell(@item1)).to eq([@vendor1, @vendor3])
      expect(@market.vendors_that_sell(@item4)).to eq([@vendor2])
    end
  end

  describe "#total_inventory" do 
    it "returns a hash with items for keys" do 
      expect(@market.total_inventory).to be_a(Hash)
      expect(@market.total_inventory.keys.all? { |key| key.class == Item }).to eq(true)
    end

    it "has a sub-hash for values, which include quantity: <int> and vendors: <array of vendors>" do 
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
      expect(@market.total_inventory[@item1]).to eq({:quantity=>100, :vendors=>[@vendor1, @vendor3]})
      expect(@market.total_inventory[@item2]).to eq({:quantity=>7, :vendors=>[@vendor1]})
      expect(@market.total_inventory[@item3]).to eq({:quantity=>35, :vendors=>[@vendor2, @vendor3]})
      expect(@market.total_inventory[@item4]).to eq({:quantity=>50, :vendors=>[@vendor2]})
    end
  end

  describe "#overstocked_items" do 
    it "returns a list 'overstocked' items (sold by more than 1 vendor, quantity > 50" do 
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
      expect(@market.overstocked_items).to eq([@item1])
    end
  end

  describe "#sorted_item_list" do 
    it "returns a list of all items the vendor's have in stock, sorted alphabetically" do 
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
      expect(@market.sorted_item_list).to eq(["Banana Nice Cream", "Peach", "Peach-Raspberry Nice Cream", "Tomato"])
    end
  end

  describe "#sell" do 
    it "returns false if there is not enough quantity" do 
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
      item5 = Item.new({name: "Onion", price: "$0.25"})
      expect(@market.sell(@item1, 200)).to eq(false)
      expect(@market.sell(item5, 1)).to eq(false)
    end

    it "returns true if there's enough quantity and reduces the stock accordingly" do 
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
      expect(@market.sell(@item4, 5)).to eq(true)
      expect(@vendor3.check_stock(@item4)).to eq(45)
      expect(@market.sell(@item1, 40)).to eq(true)
      expect(@vendor1.check_stock(@item1)).to eq(0)
      expect(@vendor3.check_stock(@item1)).to eq(60)
    end
  end
end 