# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

	me = User.create!(email: "mradzwilla@aol.com", first_name: "Mike", last_name: "Radzwilla", password: "123456")
	me.posts.create(latitude: 41.182522399999996, longitude: -75.9431374, content: "Hello", created_at: "2016-11-07 06:03:32 UTC")
	me.posts.create(latitude: 41.182522399999996, longitude: -75.9431374, content: "Is it me you're looking for?", created_at: "2016-11-07 06:03:32 UTC")

	marik = User.create!(email: "marik@yugioh.com", first_name: "Marik", last_name: "Ishtar", password: "123456")
	marik.posts.create(latitude: 30.2672, longitude: 97.7431, content: "Just sent someone to the Shadow Realm lolol", created_at: "2016-11-07 06:03:32 UTC",)
	marik.posts.create(latitude: 41.2459, longitude: 75.8813, content: "Winged Dragon of Ra is fucking sick", created_at: "2016-11-07 06:03:32 UTC",)
	marik.posts.create(latitude: 41.2054, longitude: 76.0049, content: "Chillin' in Nanticoke. This place sucks", created_at: "2016-11-07 06:03:32 UTC",)

	john_cena = User.create!(email: "johncena@wwe.com", first_name: "John", last_name: "Cena", password: "123456")
	john_cena.posts.create(latitude: 40.7128, longitude: 74.0059, content: "U Can't C Me", created_at: "2016-11-07 06:03:32 UTC",)
	john_cena.posts.create(latitude: 34.0522, longitude: 118.2437, content: "Guys I don't suck", created_at: "2016-11-07 06:03:32 UTC",)
	john_cena.posts.create(latitude: 47.6062, longitude: 122.3321, content: "AJ Style beat me :(", created_at: "2016-11-07 06:03:32 UTC",)