# require 'pg'
# require 'active_record'

# ActiveRecord::Base.logger = Logger.new(STDOUT)
# ActiveRecord::Base.establish_connection(
#   adapter: "postgresql",
#   database: "safari_vacation"
# )

# class SeenAnimal < ActiveRecord::Base
# end

# def json_print data
#   puts JSON.pretty_generate(data.as_json)
# end

# json_print SeenAnimal.all

# # number = gets.chomp
# # text = gets.chomp
# # #{number}, #{text}
# SeenAnimal.find(9).update(count_of_times_seen: "25", location_of_last_seen: "lake")

# json_print SeenAnimal.where(location_of_last_seen: "jungle")

# SeenAnimal.where("location_of_last_seen = ?", "desert").delete_all

# json_print SeenAnimal.all

# json_print SeenAnimal.sum("count_of_times_seen")

# json_print SeenAnimal.where(species: "lion").or(SeenAnimal.where(species: "tiger")).or(SeenAnimal.where(species: "bear")).sum("count_of_times_seen")


require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/json'
require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: "postgresql",
  database: "safari_vacation"
)

class SeenAnimal < ActiveRecord::Base
end


# get all animals
get '/Animals' do 
  json  SeenAnimal.all.order(:id)
end


# search one animal
get '/Search/:species' do
  json   SeenAnimal.where(species: params["species"])
end


# adds one animal to database
post '/Animal' do

  data = JSON.parse(request.body.read)

  animal_params = data["animal"]

  new_animal = SeenAnimal.create(animal_params)

  json animal: new_animal
end

# gets all animals in a certain location
get '/Animal/:location' do
  json   SeenAnimal.where(location_of_last_seen: params["location"])
end


# updates the animal seen by 1, tough one
put '/Animal/:animal' do
  data = JSON.parse(request.body.read)

  animal_params = data["animal"]


end



# deletes one animal from database
delete '/delete/:species' do 
  json animal: SeenAnimal.where(species: params["species"]).destroy
end



