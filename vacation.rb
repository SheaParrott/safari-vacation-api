
# ➜  ~ createdb safari_vacation
# ➜  ~ pgcli safari_vacation
# mmy@/tmp:safari_vacation> CREATE TABLE seen_animals (id SERIAL PRIMARY KEY, spec
#  ies TEXT, count_of_times_seen INT, location_of_last_seen TEXT)
 
#  >> class SeenAnimal < ActiveRecord::Base
#  >> end
 
#  >> SeenAnimal.all
 
#  >> SeenAnimal.find(5).update(count_of_times_seen: "25", location_of_last_seen: "Grasslands")
 
#  >> SeenAnimal.where(location_of_last_seen: "Jungle")
 
#  >> SeenAnimal.where(location_of_last_seen: "Desert").delete_all
 
#  >> SeenAnimal.sum("count_of_times_seen")
 
#  >> SeenAnimal.where(species:"Lion").or(SeenAnimal.where(species:"Tiger").or(SeenAnimal.where(species:"Bear"))).sum("count_of_times_seen")
 
