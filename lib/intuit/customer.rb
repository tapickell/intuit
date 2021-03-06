module Intuit
  class Customer < Base
    element  "Id",         :as => :id,            :class => Id
    element  "TypeOf",     :as => :type
    element  "Name",       :as => :name
    element  "Address",    :as => :address,       :class => Address
    elements "Email",      :as => :emails,        :class => Email
    element  "GivenName",  :as => :first_name
    element  "FamilyName", :as => :last_name
    element  "MiddleName", :as => :middle_name

    class << self
      def find_by_name(name)
        all(:FirstLastName => name)
      end
    end
  end
end
