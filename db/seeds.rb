# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first

name = ["Johnson","Jones","Perez","Lopez","Smith"]
city = ["Orem","Provo","Salt Lake","Ogden","West Valley","Sandy","Murray"]
address = ["200 South 700 East","500 West 100 North","25 North 699 West"]
email = "test@test.com","example@example.com","blank@gmail.com","test@hotmail.com","info@yahoo.com"
cost = [50.00,30.00,40.67,100.00,120.00]
items = ["Towel","Shirt","Bag","Shoe","Sock"]
itemCost = [5.00,10.50,3.56,40,10]
itemQuantity = [1,3,2,5,15]
itemAge = [1,20,15,8,7]
itemMember = ["John","Gary","Bob","Isaac","Bill"]
description = "Lorem ipsum lorem ipsum lorem ipsum lorem ipsum."
name.length.times do |i|
  Family.create!(name: name[i],email: email[i],cost: cost[i],phone: 5555555555,city: city[rand 0..(city.length-1)],address: address[rand 0..(city.length-1)])
end
User.create(email: "test@test.com", password: "test0101", name: "Miguel Rust",admin: true,phone: "3853094385")
Family.all.each do |f|
  rand(2..7).times do |i|
    randomItem = rand(0..(items.length-1))
    f.items.create!(name: items[randomItem], description: description, quantity: itemQuantity[randomItem], cost: itemCost[randomItem], member: itemMember[randomItem], age: itemAge[randomItem])
    f.items.last.update_attribute("totalCost",f.items.last.quantity*f.items.last.cost)
    familyCost = 0
    f.items.each do |i|
      familyCost += i.totalCost
    end
    f.update_attribute("cost",familyCost)
    f.update_attribute("lf",f.items.length)
  end
end
