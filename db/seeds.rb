# frozen_string_literal: true

require 'open-uri'

Faker::Config.locale = :ru

10.times do
  User.create(name: Faker::Name.name, email: Faker::Internet.unique.email, admin: false)
end

5.times do
  Category.create(name: Faker::Beer.style)
end

50.times do
  bulletin = Bulletin.new
  bulletin.title = Faker::Beer.brand
  bulletin.description = Faker::ChuckNorris.fact if rand > 0.25
  bulletin.image.attach(io: URI.parse(Faker::LoremFlickr.image).open, filename: 'image.jpg', content_type: 'image/jpg')
  bulletin.user = User.order(Arel.sql('RANDOM()')).first
  bulletin.category = Category.order(Arel.sql('RANDOM()')).first
  bulletin.aasm_state = %w[draft under_moderation published rejected archived].sample
  bulletin.save
end
