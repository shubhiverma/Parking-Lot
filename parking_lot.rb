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

    @parking_lot = []
    position_start  = 1

    @rows.times do
      row = []

      @columns.times do
        row.push ParkingSlot.new(position_start, @columns)
        position_start += 1
      end

      @parking_lot.push(row)
    end

    @vehicles = {}

    puts "Your parking lot is ready. Now, you can park bikes, cars or trucks. Currently available slots: #{available_slots}"
    view
  end

  def add_vehicle(type, vehicle_number, vehicle_name, slots)

    return "Vehicle number: #{vehicle_number} already parked in the parking lot." if vehicles.member? vehicle_number

    if !slots_available?(slots)
      return "Sorry, vehicle no: #{vehicle_number} cannot be placed in these parking slots. Try adding on some other slots."
    end

    slots = slots.map { |slot| @parking_lot[slot[0]][slot[1]] }

    case type
    when "bike"
      return "Bike requires 1 parking slot." if Bike::PARKING_SLOTS_NEEDED != slots.length
      vehicles[vehicle_number] = Bike.new(vehicle_number, vehicle_name)

    when "car"
      return "Car requires 2 parking slots." if Car::PARKING_SLOTS_NEEDED != slots.length
      car = Car.new(vehicle_number, vehicle_name)

      return "Slots should be adjacent." if !car.can_occupy_slots? slots
      vehicles[vehicle_number] = car

    when "truck"
      return "Truck requires 4 parking slots." if Truck::PARKING_SLOTS_NEEDED != slots.length
      truck = Truck.new(vehicle_number, vehicle_name)

      return "Slots should be adjacent." if !truck.can_occupy_slots? slots
      vehicles[vehicle_number] = truck
    end

    vehicles[vehicle_number].slots = slots

    vehicles[vehicle_number].slots.each do |slot|
      slot.vehicle = vehicles[vehicle_number]
    end

    return "#{vehicle_name} with vehicle no: #{vehicle_number} added."
  end

  def remove_vehicle(vehicle_number)

    return "Vehicle does not exist." if !vehicles.member?(vehicle_number)

    vehicles.fetch(vehicle_number).slots.each do |slot|
      slot.vehicle = nil
    end

    vehicles.delete vehicle_number

    return "Vehicle with vehicle number: #{vehicle_number} removed from the parking lot."
  end

  def slots_available?(slots)

    begin
      slots = slots.map { |slot| @parking_lot[slot[0]][slot[1]] }
      slots.all? { |slot| !slot.vehicle }
    rescue
      return false
    end
  end

  def available_slots

    slots = 0

    for row in parking_lot
      slots += row.count {|slot| !slot.vehicle}
    end

    slots
  end

  def parked_vehicles

    parked = {bikes: 0, cars: 0, trucks: 0}

    vehicles.each do |key, value|

      if value.class == Car
        parked[:cars] += 1
      elsif value.class == Bike
        parked[:bikes] += 1
      elsif value.class == Truck
        parked[:trucks] += 1
      end
    end

    parked
  end

  def view

    puts "-" * 100
    puts "\t\t\t\t\tParking Lot"
    puts "-" * 100

    parking_lot.each do |row|
      row.each { |column| print "S: #{column.location}, #{column.vehicle ? column.vehicle.vehicle_name : "nil"} \t" }
      print "\n"
    end

    puts "#{'-' * 43}Parked Vehicles#{'-' * 42}"

    parked_vehicles.each do |key, value|
      print "#{key.upcase}: #{value} \t\t"
    end

    puts "Currently Available slots: #{available_slots}"
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

        print "Enter the slot number? "
        locations = gets.chomp

        locations = locations.split.map{|location| coordinates location.to_i}
        puts add_vehicle vehicle_type, vehicle_number, vehicle_name, locations
      elsif input == 'r'
        if vehicles.size.zero?
          puts "There are no vehicles in the parking lot. Try adding some first."
        else
          puts "Enter the vehicle number you wish to remove. "
          vehicle_number = gets.chomp
          puts remove_vehicle vehicle_number
        end
      else
        puts "Invalid input."
      end

      view

      print "Wish to continue? y / n "
      user_input = gets.chomp.downcase
    end
  end

  def coordinates location
    [(location - 1) / columns, (location - 1) % columns]
  end

end

class ParkingSlot

  attr_accessor :vehicle, :location, :parking_lot_columns

  def initialize(location, parking_lot_columns)
    @vehicle = nil
    @location = location
    @parking_lot_columns = parking_lot_columns
  end

  def adjacent_locations
    [
        location - parking_lot_columns,
        location + 1,
        location + parking_lot_columns,
        location - 1
    ]
  end
end

parking_lot = ParkingLot.new

# puts parkingLot.add_vehicle("truck", "HR 12A 3456", "Volvo", [[1,2], [1,3], [2,2], [2,3]])
# puts parkingLot.add_vehicle("bike", "CH 01A 2345", "Honda", [[3,3]])

# puts parkingLot.remove_vehicle "CH 01A 2345"

parking_lot.run
# parking_lot.view