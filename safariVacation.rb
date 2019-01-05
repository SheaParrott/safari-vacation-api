
require 'sinatra'
require 'sinatra/json'
require 'sinatra/reloader' if development?
require 'active_record'
require 'rack/cors'

# Allow anyone to access our API via a browser
use Rack::Cors do |config|
  config.allow do |allow|
    allow.origins '*'
    allow.resource '*'
  end
end

# Connects ActiveRecord to our safari database
ActiveRecord::Base.establish_connection(
  adapter: "postgresql",
  database: "safari_vacation"
)

# Make a class that allows us to work with the database.
class SeenAnimal < ActiveRecord::Base
end

# Create `GET /Animals` Endpoint that returns all animals you have seen
get '/Animals' do
  json SeenAnimal.all
end

# Create `GET /Search?species=lion` that returns all animals where the species name contains the species parameter
get '/Search' do
  json SeenAnimal.where('species LIKE ?', "%#{params["species"]}%")
end

# Create a `POST /Animal` endpoints that adds a animal to the database. This should take a JSON body
# JSON body looks like:
# {
#    "seen_animal": {
#      "species": "Duck",
#      "count_of_times_seen": 10,
#      "location_of_last_seen": "Kitchen"
#    }
# }
post '/Animal' do
  animal_json_object = JSON.parse(request.body.read)

  animal_active_record_object = SeenAnimal.create(animal_json_object["seen_animal"])

  json animal_active_record_object
end

# Create a `GET /Animal/{location}` that returns animals of only that location
get '/Animal/:location' do
  json SeenAnimal.where(location_of_last_seen: params["location"])
end

# Create a `PUT /Animal/{id}` endpoint that adds 1 to the count of times seen for that animal
put '/Animal/:id' do
  SeenAnimal.where(id: params["id"]).update_all("count_of_times_seen = count_of_times_seen + 1")

  json SeenAnimal.find(params["id"])
end

# Create a `DELETE /Animal/{id}` endpoint that deletes that animal id from the database
delete '/Animal/:id' do
  found_animal = SeenAnimal.find(params["id"])

  found_animal.destroy

  json found_animal
end
# # Create a `DELETE /Animal/{location}` 
# delete '/Animal/:location' do
#   json SeenAnimal.where(location_of_last_seen: params["location"]).destroy
# end


# # Delete animals from the table by location
# delete '/Animal/:location' do
#   deleted_animal = SeenAnimal.where(location_of_last_seen: params["location"])
#   deleted_animal.destroy
#   json animals: deleted_animal
# end

# Add the count of times seen
get '/Count' do
  json total_count_of_times_seen: SeenAnimal.sum("count_of_times_seen")
end

# # Add the count of times seen for Lion, Tiger, Bear
get '/Count/LTB' do
  json total_count_of_times_seen_LTB: SeenAnimal.where(species: "lion").or(SeenAnimal.where(species: "tiger")
  .or(SeenAnimal.where(species: "bear"))).sum("count_of_times_seen")
  
end