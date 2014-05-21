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

  create_table :evil_plots do |t|
    t.string :codename
    t.string :description
    t.integer :overlord_id
  end

  create_table :evil_plot_attendances do |t|
    t.integer :evil_henchmen_id
    t.integer :evil_plot_id
  end
end

class EvilHenchmen < ActiveRecord::Base
  has_many :minions, class_name: "EvilHenchmen", foreign_key: :overlord_id
  belongs_to :overlord, class_name: "EvilHenchmen"
  has_many :hatched_evil_plots, class_name: "EvilPlot", foreign_key: :overlord_id
  has_many :evil_plot_attendances
  has_many :evil_plots_being_carried_out, through: :evil_plot_attendances, source: :evil_plot
end

class EvilPlotAttendance < ActiveRecord::Base
  belongs_to :evil_henchmen
  belongs_to :evil_plot
end

class EvilPlot < ActiveRecord::Base
  belongs_to :overlord, class_name: "EvilHenchmen"
  has_many :evil_plot_attendances
  has_many :minions, through: :evil_plot_attendances, source: :evil_henchmen
end

sauron = EvilHenchmen.create!(name: "Sauron", weapon: "Mace")

saruman = EvilHenchmen.create!(name: "Saruman", weapon: "Magic")

sauron.minions << saruman

uruk_hai = EvilHenchmen.create!(name: "Uruk-hai", weapon: "Pretty much anything")

saruman.minions << uruk_hai

bind_them_all = EvilPlot.create(codename: "pretty_glitter", description: "Corrupt them all to my will")

sauron.hatched_evil_plots << bind_them_all

bind_them_all.minions << saruman

sauron.minions
saruman.overlord
sauron.hatched_evil_plots
bind_them_all.overlord

binding.pry