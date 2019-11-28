class Vehicle

  attr_reader :vehicle_number, :vehicle_name, :slots
  attr_writer :slots

  def initialize(vehicle_number, vehicle_name)
    @vehicle_number = vehicle_number
    @vehicle_name = vehicle_name

    @slots = []
  end
end

class Bike < Vehicle

  PARKING_SLOTS_NEEDED = 1
end

class Car < Vehicle

  PARKING_SLOTS_NEEDED = 2

  def can_occupy_slots?(slots)

    slots[0].adjacent_locations.include? slots[1].location
  end
end

class Truck < Vehicle

  PARKING_SLOTS_NEEDED = 4

  def can_occupy_slots?(slots)

    locations = slots.map{ |slot| slot.location }

    slots.all? { |slot| (slot.adjacent_locations & locations).length == 2 }
  end
end
