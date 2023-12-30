# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

### Users Seed ###
db_seed_users = [
  {:email => 'lionelmessi@gmail.com', :password => 'lionelmessi1234', :name => 'Lionel', :surname => 'Messi',
   :national_identification_number => 'L10000000M', :date_of_birth => '24-Jun-1987', :phone_number => '0690000010', :role => 'Administrator'},
  {:email => 'cristianoronaldo@gmail.com', :password => 'cristianoronaldo1234', :name => 'Cristiano', :surname => 'Ronaldo',
   :national_identification_number => 'C00000007R', :date_of_birth => '02-Feb-1985', :phone_number => '0690000007', :role => 'Administrator'},
  {:email => 'kylianmbappe@gmail.com', :password => 'kylianmbappe1234', :name => 'Kylian', :surname => 'Mbappe',
   :national_identification_number => 'K00000007M', :date_of_birth => '20-Dec-1998', :phone_number => '0690000107', :role => 'Individual'},
  {:email => 'erlinghaaland@gmail.com', :password => 'erlinghaaland1234', :name => 'Erling', :surname => 'Haaland',
   :national_identification_number => 'E00000009H', :date_of_birth => '21-Jul-2000', :phone_number => '0690000009', :role => 'Individual'},
]

db_seed_users.each do |user|
  User.create(user)
end

### Notifications Seed ###
db_seed_notifications = [
  {:subject => 'What is Lorem Ipsum?', :body => 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
   :published => true},
  {:subject => 'Where does it come from?', :body => 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.',
   :published => false},
  {:subject => 'Where can I get some?', :body => 'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don\'t look even slightly believable.',
   :published => false},
]

db_seed_notifications.each do |notification|
  Notification.create(notification)
end
