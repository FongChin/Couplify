class EmailError < ActiveRecord::Base
  attr_accessible :error_msg, :params
end