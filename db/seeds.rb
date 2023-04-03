10.times do 
  Book.create!(
    name: Faker::Book.title,
    author: Faker::Book.author,
    gender: Faker::Book.genre 
  )
end