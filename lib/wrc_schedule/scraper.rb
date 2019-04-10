

class WrcSchedule::Scraper

#Scrapes the WRC Calendar page and returns an array of event hashes
  def self.scrape_calendar_page(calendar_url)
    doc = Nokogiri::HTML(open(calendar_url))
    array_of_events=[]
    event_html=doc.css("tr")
    event_html.each_with_index{|event, index|
      event_hash={
        name: event.css("a.nolink").text,
        dates: event.css("td.aright a")[0].text,
        event_url: "https://www.wrc.com"+event.css("a.nolink").first["href"],
        index: index+1
      }
      if event.css("td a").size>3
        event_hash[:winner]=event.css("td a")[3].text
        event_hash[:results_url]= "https://www.wrc.com"+event.css("td a")[4].first[1]
      end
      array_of_events << event_hash
    }
    array_of_events
  end

#Scrapes an individual event's page and returns a hash of attributes
  def self.scrape_event_page(event_url)
    doc = Nokogiri::HTML(open(event_url))
    section= doc.css("table tr")
    attribute_hash={}
    section.each {|tr|
      td=tr.css("td")
      case td[0].text
      when "Timezone:"
        attribute_hash[:timezone]=td[1].text
      when "Servicepark:"
        attribute_hash[:service_park]=td[1].text
      when "Stages:"
        attribute_hash[:stages]=td[1].text
      when "Distance:"
        attribute_hash[:distance]=td[1].text
      when "Website:"
        attribute_hash[:website]=td[1].text
      end
    }
    attribute_hash
  end

#Scrapes the results page of an event and returns an array or car attribute hashes
  def self.scrape_results_page(results_url)
    browser = Watir::Browser.new :chrome, headless: true
    browser.goto results_url
    sleep 1
    doc = Nokogiri::HTML.parse(browser.html)
    browser.close
    rows=doc.css("div.scrolltable table tbody tr")
    results_array=[]
    rows.each_with_index{|row, index|
      if index < 20
        cells=row.css("td")
        car_attributes={}
        cells.each_with_index{|cell, index|
          case index
          when 0
            car_attributes[:place]=cell.text.strip
          when 1
            car_attributes[:number]=cell.text.strip
          when 2
            car_attributes[:driver]=cell.text.strip
          when 3
            car_attributes[:codriver]=cell.text.strip
          when 4
            car_attributes[:team]=cell.text.strip
          when 5
            car_attributes[:eligability]=cell.text.strip
          when 7
            car_attributes[:time]=cell.text.strip
          when 8
            car_attributes[:dif_prev]=cell.text.strip
          when 9
            car_attributes[:dif_first]=cell.text.strip
          end
        }
        results_array << car_attributes
      end
    }
    results_array
  end

end
