require "rspec"
require "./lib/item"

RSpec.describe Item do 
  before(:each) do 
    @item1 = Item.new({name: "Peach", price: "$0.75"})
  end
  
  describe "#initialize" do 
    it "exists" do 
      expect(@item1).to be_an_instance_of(Item)
    end

    it "has readable name and price attributes" do 
      expect(@item1.name).to eq("Peach")
      expect(@item1.price).to eq(0.75)
    end
  end
end