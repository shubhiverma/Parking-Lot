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

    first_location = slots[0].location

    if ([
        first_location + 1, first_location - 1,
        first_location + slots[0].parking_lot_columns, first_location - slots[0].parking_lot_columns
        ].include? slots[1].location)
      return true
    end

    return false
  end
end

class Truck < Vehicle

  PARKING_SLOTS_NEEDED = 4

  def can_occupy_slots?(slots)
  end
end
