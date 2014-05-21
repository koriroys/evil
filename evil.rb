require 'active_record'
require 'logger'
require 'pry'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'
ActiveRecord::Base.logger = Logger.new $stdout
ActiveSupport::LogSubscriber.colorize_logging = false

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :evil_henchmen do |t|
    t.string :name
    t.string :weapon
  end
end

class EvilHenchmen < ActiveRecord::Base

end

sauron = EvilHenchmen.create!(name: "Sauron", weapon: "Mace")

binding.pry