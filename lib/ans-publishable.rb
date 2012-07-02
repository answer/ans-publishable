require "ans-publishable/version"

module Ans
  module Publishable
    autoload :Methods, "ans-publishable/methods"
    autoload :InstanceMethods, "ans-publishable/instance_methods"

    def self.included(m)
      m.extend Ans::Publishable::Methods
      m.send :include, Ans::Publishable::InstanceMethods
    end
  end
end
