require "spec_helper"

describe FactoryGirl::Upgrader::Transformer do
  
  describe "old factory_girl V1 factory" do
    subject { '
      Factory.define(:product) do |f|
        f.association :category
        f.price 19.95
        f.sequence(:name) {|n| "Product #{n}" }
      end
    ' }
    
    it { should transform_to("new factory_girl V2 factory", '
      FactoryGirl.define do
        factory(:product) do
          category
          price(19.95)

          sequence(:name) do |n|
            "Product #{n}"
          end
        end
      end
    ') }
  end
  
end
