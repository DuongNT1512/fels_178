# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin = User.create name: "admin",
  email: "admin@gmail.com",
  password: "1",
  password_confirmation: "1",
  role: 1
User.create name: "duong",
  email: "1@gmail.com",
  password: "1",
  password_confirmation: "1"

40.times do |n|
  name  = Faker::Name.name
  email = "user-#{n+1}@gmail.com"
  password = "1"
  role = 0
  User.create! name: name, email: email, password: password,
    password_confirmation: password, role: role
end

users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each {|followed| user.follow(followed)}
followers.each {|follower| follower.follow(user)}


10.times do |category|
  name  = "Category #{category+1}"
  description = "Here is the description of the #{category+1} course"
  Category.create!(name:  name, description: description)
end

5.times do |category|
  category_id = category+1;
  20.times do |i|
    content = "question #{i+1} #{category_id}"
    word = Word.create!(category_id: category_id, content: content)
    content_answer1 = "content 1"
    Answer.create!(word_id:  word.id, content: content_answer1, is_correct: true)
    content_answer2 = "content 2"
    Answer.create!(word_id:  word.id, content: content_answer2, is_correct: false)
    content_answer3 = "content 3"
    Answer.create!(word_id:  word.id, content: content_answer3, is_correct: false)
    content_answer4 = "content 4"
    Answer.create!(word_id:  word.id, content: content_answer4, is_correct: false)
  end
end
