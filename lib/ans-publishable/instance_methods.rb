module Ans::Publishable::InstanceMethods

  def revert_publish
    self.send :"#{self.class.publish_foreign_key}=", nil
    save
  end

end
