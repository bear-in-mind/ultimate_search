class ApplicationRecord < ActiveRecord::Base
  include CableReady::Updatable
  include CableReady::Broadcaster
  primary_abstract_class
end
