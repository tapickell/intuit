module Intuit
  class Item < Base
    autoload :AccountRef, "intuit/item/account_ref"

    include SAXMachine

    element "Id",                :as => :id,             :class => Id
    element "ItemParentId",      :as => :parent_id,      :class => Id
    element "ItemParentName",    :as => :parent_name
    element "Name",              :as => :name
    element "Desc",              :as => :description
    element "Active",            :as => :active
    element "UnitPrice",         :as => :price,          :class => Money
    element "Type",              :as => :type
    element "IncomeAccountRef",  :as => :income_account, :class => AccountRef
    element "PurchaseCost",      :as => :purchase_cost,  :class => Money
    element "COGSAccountRef",    :as => :cogs_account,   :class => AccountRef
    element "AssetAccountRef",   :as => :asset_account,  :class => AccountRef

    def self.find_by_type(*types)
      all.select { |a| Array.wrap(types).include?(a.type) }
    end

    def self.find_by_name(name)
      all.select do |item|
        item.name =~ %r{#{name.downcase}}i
      end
    end

    def full_name
      [parent_name, name].compact.join(":")
    end
  end
end
