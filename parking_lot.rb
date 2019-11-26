require './vehicle'

class ParkingLot

  attr_reader :rows, :columns
  attr_accessor :parking_lot, :vehicles

  def initialize

    puts "Hola! Set up your parking lot"

    print "Enter the rows in the parking lot. "
    @rows = gets.chomp.to_i

    print "Enter the columns in the parking lot. "
    @columns = gets.chomp.to_i

    @parking_lot = Array.new(rows) {Array.new(columns)}
    @vehicles = {}

    puts "Your parking lot is ready. Now, you can park bikes, cars or trucks. Currently available slots: #{available_slots}"
  end

  def add_vehicle(type, vehicle_no, name, slots)

    return "Sorry, vehicle no: #{vehicle_no} cannot be placed in these parking slots." if !(slots.all? {|slot| slot_available?(slot[0] - 1, slot[1] - 1)})

    case type
    when "bike"
      return "Invalid number of parking slots." if Bike::PARKING_SLOTS_NEEDED != slots.length
      vehicles[vehicle_no] = Bike.new(vehicle_no, name)

    when "car"
      return "Invalid number of parking slots." if Car::PARKING_SLOTS_NEEDED != slots.length
      vehicles[vehicle_no] = Car.new(vehicle_no, name)

    when "truck"
      return "Invalid number of parking slots." if Truck::PARKING_SLOTS_NEEDED != slots.length
      vehicles[vehicle_no] = Truck.new(vehicle_no, name)
    end

    vehicles[vehicle_no].slots = slots
    place_vehicle vehicles[vehicle_no]
  end

  def place_vehicle(vehicle)

    vehicle.slots.each do |slot|
      parking_lot[slot[0] - 1][slot[1] - 1] = vehicle.name
    end

    return "#{vehicle.name} with vehicle no: #{vehicle.vehicle_number} added."
  end

  def remove_vehicle(vehicle_number)

    vehicles.fetch(vehicle_number).slots.each do |slot|
      parking_lot[slot[0]][slot[1]] = nil
    end

    vehicles.delete vehicle_number

    return "Vehicle with vehicle number: #{vehicle_number} removed from the parking lot."
  end

  def slot_available?(row, column)

    return false if row < 0 || row >= @rows;
    return false if column < 0 || column >= @columns;

    parking_lot[row][column].nil?
  end

  def available_slots

    slots = 0

    for row in parking_lot
      slots += row.count {|slot| slot.nil?}
    end

    slots
  end

  def view

    puts "--------------------------"
    puts "\tParking Lot"
    puts "--------------------------"

    for row in parking_lot
      p row
    end
  end

end

parkingLot = ParkingLot.new

puts parkingLot.add_vehicle("truck", "HR 12A 3456", "Volvo", [[1,2], [1,3], [2,2], [2,3]])
puts parkingLot.add_vehicle("bike", "CH 01A 2345", "Honda", [[3,3]])

# puts parkingLot.remove_vehicle "CH 01A 2345"

parkingLot.view