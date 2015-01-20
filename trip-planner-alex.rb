require 'pry'
require 'HTTParty'
require 'CGI'


class TripPlanner
attr_reader :user, :forecast, :recommendation
	def initialize
	end

	def plan
		@user = self.create_user
		@forecast = self.retrieve_forecast
		@recommendation = self.create_recommendation
		puts ("The forecast will be #{@forecast}, we recommend bringing #{@recommendation}").to_s
	end

	def create_user
		puts "Please enter your name."
		@name = gets.chomp
		puts "Please enter your destination."
		@destination = gets.chomp
		puts "Please enter how many days you will be staying."
		@duration = gets.chomp.to_i
		@user = User.new(@name, @destination, @duration)
	end

	def call_api
		units = "imperial"
     	options = "daily?q=#{CGI.escape(@destination)}&mode=json&units=#{units}&cnt=#{@duration}"
     	url = "http://api.openweathermap.org/data/2.5/forecast/#{options}"
     	@result = HTTParty.get(url)
	end

	def parse_result
		@forecast = []
		forecast_array = @result["list"]
		Pry.start(binding)
		forecast_array.each do |i| 		
			min_temp = forecast_array[i]["temp"]["min"].floor
        	max_temp = [forecast_array[i]["temp"]["max"].ceil
        	condition = [forecast_array[i]["weather"][0]["main"]
      	@forecast << Weather.new(min_temp, max_temp, condition)
		end
	end

	def retrieve_forecast
		self.call_api
		Pry.start(binding)
		self.parse_result
	end

	def create_recommendation
	end

end

class Weather
attr_reader :min_temp, :max_temp, :condition 

	CLOTHES = [
		{
	   		min_temp: -50, max_temp: 0,
      		suggestions: [
        		"insulated parka", "long underwear", "fleece-lined jeans",
        		"mittens", "knit hat", "chunky scarf"
      		]
    	},

    	{
    		min_temp: 1, max_temp: 60,
    		suggestions: [
    			"long coat", "jeans", "gloves", "ear muffs", "long sleeve shirt", "sweater"
    		]
    	},

    	{
    		min_temp: 60, max_temp: 75,
    		suggestions: [
    			"windbreaker", "hoodie", "ringer tee", "casual pants"
    		] 
    	},

    	{
    		min_temp: 76, max_temp: 100,
    		suggestions: [
    			"tee shirt", "shorts", "sandals", "briefs"
    		]
    	}
	]

	ACCESORIES = [
		{
			condition: "Rainy",
			suggestions: [
				"galoshes", "umbrella"
			]
		},

		{
			condition: "Clear",
			suggestions: [
				"Sunglasses", "Sunscreen"
			]
		},

		{
			condition: "Snow",
			suggestions: [
				"Shovel", "Hand Warmers", "Brush"
			]
		}
	]
	
	def initialize(min_temp, max_temp, condition)
		@min_temp = min_temp
		@max_temp = max_temp
		@condition = condition
	end

	def appropriate_clothing

	end


	def appropriate_accesories

	end

	def self.clothing_for

	end


	def self.accessories_for

	end

end

class User
attr_accessor :name, :destination, :duration
	def initialize(name, destination, duration)
		@name = name
		@destination = destination
		@duration = duration
	end
end


trip_planner = TripPlanner.new
Pry.start(binding)
#trip_planner.plan