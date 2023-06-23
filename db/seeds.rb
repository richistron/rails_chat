# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

if ENV['RAILS_ENV'] == 'development'
  User.create! username: 'richistron', password: 'panchito', password_confirmation: 'panchito',
               is_admin: true, uuid: '62010a9f-f6a0-4d2a-8a06-15ba49281b61'
  Chat::Channel.create! name: 'general'
end
