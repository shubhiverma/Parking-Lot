class Vehicle

  attr_reader :vehicle_number, :name, :slots
  attr_writer :slots

  def initialize(vehicle_number, name)
    @vehicle_number = vehicle_number
    @name = name

    @slots = []
  end
end

class Bike < Vehicle

  PARKING_SLOTS_NEEDED = 1

end

class Car < Vehicle

  PARKING_SLOTS_NEEDED = 2

end

class Truck < Vehicle

  PARKING_SLOTS_NEEDED = 4

end
