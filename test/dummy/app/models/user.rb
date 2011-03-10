class User < ActiveRecord::Base
  before_destroy do
    if self.name == "Undestroyable"
      self.errors.add(:base, "is undestroyable")
      false
    end
  end
end
