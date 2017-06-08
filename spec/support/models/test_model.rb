class TestModel < ActiveRecord::Base
  include SanitizeOrder

  default_scope { order(:name) }
end
