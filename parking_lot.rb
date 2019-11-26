require './vehicle'
require 'json'

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
    puts "-----------------------------------------------------------------------------------------------------"
  end

  def add_vehicle(type, vehicle_number, vehicle_name, slots)

    return "Sorry, vehicle no: #{vehicle_number} cannot be placed in these parking slots. Try adding with other slots." if !(slots.all? {|slot| slot_available?(slot[0] - 1, slot[1] - 1)})

    case type
    when "bike"
      return "Invalid number of parking slots." if Bike::PARKING_SLOTS_NEEDED != slots.length
      vehicles[vehicle_number] = Bike.new(vehicle_number, vehicle_name)

    when "car"
      return "Invalid number of parking slots." if Car::PARKING_SLOTS_NEEDED != slots.length
      vehicles[vehicle_number] = Car.new(vehicle_number, vehicle_name)

    when "truck"
      return "Invalid number of parking slots." if Truck::PARKING_SLOTS_NEEDED != slots.length
      vehicles[vehicle_number] = Truck.new(vehicle_number, vehicle_name)
    end

    vehicles[vehicle_number].slots = slots

    vehicles[vehicle_number].slots.each do |slot|
      parking_lot[slot[0] - 1][slot[1] - 1] = vehicle_name
    end

    return "#{vehicle_name} with vehicle no: #{vehicle_number} added."
  end

  def remove_vehicle(vehicle_number)

    p vehicles.fetch(vehicle_number).slots

    vehicles.fetch(vehicle_number).slots.each do |slot|
      p slot
      parking_lot[slot[0] - 1][slot[1] - 1] = nil
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

  def run

    user_input = ""

    while user_input != "n"

      puts "Would you like to add or remove vehicle? a / r "
      input = gets.chomp.downcase

      if input == 'a'
        puts "Enter the vehicles entering the parking lot."

        print "Vehicle Type? car / bike / truck "
        vehicle_type = gets.chomp

        print "Vehicle Number? "
        vehicle_number = gets.chomp

        print "Vehicle Name? "
        vehicle_name = gets.chomp

        print "Slots? "
        slots = gets.chomp

        puts add_vehicle vehicle_type, vehicle_number, vehicle_name, JSON.parse(slots)
      elsif input == 'r'
        puts "Enter the vehicle number you wish to remove. "
        vehicle_number = gets.chomp

        puts remove_vehicle vehicle_number
      else
        puts "Invalid input."
      end

      view

      print "Wish to continue? y / n "
      user_input = gets.chomp.downcase
    end
  end

end

parkingLot = ParkingLot.new

# puts parkingLot.add_vehicle("truck", "HR 12A 3456", "Volvo", [[1,2], [1,3], [2,2], [2,3]])
# puts parkingLot.add_vehicle("bike", "CH 01A 2345", "Honda", [[3,3]])

# puts parkingLot.remove_vehicle "CH 01A 2345"

parkingLot.run
# parkingLot.view