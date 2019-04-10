#CLI controller

class WrcSchedule::CLI
CALENDAR_URL="https://www.wrc.com/en/wrc/calendar/calendar/page/671-29772-16--.html"
  #runs the CLI
  def call
    create_schedule
    start_menu
  end


  def create_schedule
    event_array=WrcSchedule::Scraper.scrape_calendar_page(CALENDAR_URL)
    event_array.each{|event| WrcSchedule::Event.new(event)}
  end

  def print_schedule
    rows=[]
    WrcSchedule::Event.all.each{|event|
      row=["#{event.index}. ", event.name, event.dates]
      event.winner ? row << event.winner : row << ""
      rows << row
    }
    table = Terminal::Table.new :title => "Current World Rally Championship Schedule:", :headings => ['Index', 'Name', 'Dates', 'Winner'], :rows => rows
    puts table
    puts "Would you like to see event info or event results?"
  end

  def start_menu
    input=""
    while input!="exit"
      print_schedule
      while input!="exit"
        puts "Type 'info', 'results', or 'exit'"
        input=gets.strip.downcase
        if input == "info"
          loop_info
        elsif input == "results"
          loop_results
        elsif input != "exit"
          puts "Please enter a valid command."
        end
      end
    end
  end

  def loop_info
    input=""
    puts "Which event would you like to see more info on? Enter the event's index or enter 'menu' to return to the main menu."
    while input !="menu"
      input=gets.strip.downcase
      index=input.to_i
      if index > 0 && index <= WrcSchedule::Event.max_index && input!="menu"
        event=WrcSchedule::Event.find_by_index(index)
        add_event_info(event) if !event.timezone
        print_event_info(event)
        puts "Enter another event's index to see more info on that event. Otherwise, enter 'menu' to return to the main menu."
      elsif input!= "menu"
        puts "Please enter a valid event index or 'menu' to return to the main menu."
      elsif input == "menu"
        print_schedule
      end
    end
  end

  def loop_results
    input=""
    puts "Which event would you like to see the results of? Enter the event's index or enter 'menu' to return to the main menu."
    while input !="menu"
      input=gets.strip.downcase
      index=input.to_i
      if index > 0 && index <= WrcSchedule::Event.max_index && input!="menu"
        event=WrcSchedule::Event.find_by_index(index)
        if event.winner
          add_event_results(event) if event.cars==[]
          print_event_results(event)
        else
          puts "That event has not been completed yet."
        end
        puts "Enter another event's index to see the results of that event. Otherwise, enter 'menu' to return to the main menu."
      elsif input!= "menu"
        puts "Please enter a valid event index or 'menu' to return to the main menu."
      elsif input == "menu"
        print_schedule
      end
    end
  end

  def add_event_results(event)
    url=event.results_url
    results=WrcSchedule::Scraper.scrape_results_page(url)
    create_cars_from_results(results, event)
  end

  def create_cars_from_results(results, event)
    results.each{|car_attributes|
      car_attributes[:event]=event
      WrcSchedule::Car.new(car_attributes)
    }
  end

  def print_event_results(event)
    rows=[]
    event.cars.each{|car|
      row=[car.place, car.number, car.driver, car.codriver, car.team, car.eligability, car.time, car.dif_prev, car.dif_first]
      rows << row
    }
    table = Terminal::Table.new :title => event.name, :headings => ['Place', 'Car Number', 'Driver', 'Co-driver', 'Team', 'Eligability', 'Time', 'Dif Previous', 'Dif First'], :rows => rows
    puts table
  end

  def add_event_info(event)
    url=event.event_url
    attribute_hash=WrcSchedule::Scraper.scrape_event_page(url)
    event.add_event_info(attribute_hash)
  end

  def print_event_info(event)
    rows=[]
    if event.dates
      row=["Dates", event.dates]
      rows << row
    end
    if event.timezone
      row=["Timezone", event.timezone]
      rows << row
    end
    if event.stages
      row=["Stages", event.stages]
      rows << row
    end
    if event.distance
      row=["Distance", event.distance]
      rows << row
    end
    if event.service_park
      row=["Service Park", event.service_park]
      rows << row
    end
    if event.website
      row=["Website", event.website]
      rows << row
    end

    table = Terminal::Table.new :title => event.name, :rows => rows
    puts table
  end

end
