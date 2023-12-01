# frozen_string_literal: true

Rails.root.glob('db/seeds/*.rb') do |path|
  desc "Load the seed data from db/seeds/#{path.basename}."
  task "db:seed:#{path.basename('.*')}" => :environment do
    load(path)
  end
end
