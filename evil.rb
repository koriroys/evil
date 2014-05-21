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
    t.integer :overlord_id
  end
end

class EvilHenchmen < ActiveRecord::Base
  has_many :minions, class_name: "EvilHenchmen", foreign_key: :overlord_id
  belongs_to :overlord, class_name: "EvilHenchmen"
end

sauron = EvilHenchmen.create!(name: "Sauron", weapon: "Mace")

saruman = EvilHenchmen.create!(name: "Saruman", weapon: "Magic")

sauron.minions << saruman

uruk_hai = EvilHenchmen.create!(name: "Uruk-hai", weapon: "Pretty much anything")

saruman.minions << uruk_hai

sauron.minions
saruman.overlord

binding.pry