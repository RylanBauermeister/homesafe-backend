class Crime < ApplicationRecord

  def self.getMostRecent

    crimes = {}

    crimesAgainstPersons = HTTParty.get('https://gisrevprxy.seattle.gov/arcgis/rest/services/SPD_EXT/911IncidentResponses/MapServer/0/query?f=json&where=(mapcategory%20%3D%20%27Assault%27)%20OR%20(mapcategory%20%3D%20%27DriveBy%27)%20OR%20(mapcategory%20%3D%20%27Homicide%27)%20OR%20(mapcategory%20%3D%20%27Robbery%27)%20OR%20(mapcategory%20%3D%20%27Threats%27)&returnGeometry=true&spatialRel=esriSpatialRelIntersects&geometryType=esriGeometryEnvelope&outFields=*')
    crimes[:crimesAgainstPersons] = JSON.parse(crimesAgainstPersons)["features"]

    propertyCrime = HTTParty.get('https://gisrevprxy.seattle.gov/arcgis/rest/services/SPD_EXT/911IncidentResponses/MapServer/0/query?f=json&where=(mapcategory%20%3D%20%27Bike%27)%20OR%20(mapcategory%20%3D%20%27Burglary%27)%20OR%20(mapcategory%20%3D%20%27CarProwl%27)%20OR%20(mapcategory%20%3D%20%27Fraud%27)%20OR%20(mapcategory%20%3D%20%27OtherProp%27)%20OR%20(mapcategory%20%3D%20%27PropDamage%27)%20OR%20(mapcategory%20%3D%20%27Shoplifting%27)%20OR%20(mapcategory%20%3D%20%27VehicleTheft%27)&returnGeometry=true&spatialRel=esriSpatialRelIntersects&geometryType=esriGeometryEnvelope&inSR=102100&outFields=*&outSR=102100')
    crimes[:propertyCrime] = JSON.parse(propertyCrime)["features"]

    drugsAndVice = HTTParty.get('https://gisrevprxy.seattle.gov/arcgis/rest/services/SPD_EXT/911IncidentResponses/MapServer/0/query?f=json&where=(mapcategory%20%3D%20%27Liquor%27)%20OR%20(mapcategory%20%3D%20%27Narcotics%27)%20OR%20(mapcategory%20%3D%20%27OtherVice%27)%20OR%20(mapcategory%20%3D%20%27Prostitution%27)&returnGeometry=true&spatialRel=esriSpatialRelIntersects&geometryType=esriGeometryEnvelope&inSR=102100&outFields=*&outSR=102100')
    crimes[:drugsAndVice] = JSON.parse(drugsAndVice)["features"]

    crisisAndInjury = HTTParty.get('https://gisrevprxy.seattle.gov/arcgis/rest/services/SPD_EXT/911IncidentResponses/MapServer/0/query?f=json&where=(mapcategory%20%3D%20%27Crisis%27)%20OR%20(mapcategory%20%3D%20%27Injury%27)%20OR%20(mapcategory%20%3D%20%27Lost%27)&returnGeometry=true&spatialRel=esriSpatialRelIntersects&geometryType=esriGeometryEnvelope&inSR=102100&outFields=*&outSR=102100')
    crimes[:crisisAndInjury] = JSON.parse(crisisAndInjury)["features"]

    trafficCrime = HTTParty.get('https://gisrevprxy.seattle.gov/arcgis/rest/services/SPD_EXT/911IncidentResponses/MapServer/0/query?f=json&where=(mapcategory%20%3D%20%27Collision%27)%20OR%20(mapcategory%20%3D%20%27DUI%27)%20OR%20(mapcategory%20%3D%20%27Harbor%27)%20OR%20(mapcategory%20%3D%20%27Traffic%27)&returnGeometry=true&spatialRel=esriSpatialRelIntersects&geometryType=esriGeometryEnvelope&inSR=102100&outFields=*&outSR=102100')
    crimes[:trafficCrime] = JSON.parse(trafficCrime)["features"]

    miscCrimes = HTTParty.get('https://gisrevprxy.seattle.gov/arcgis/rest/services/SPD_EXT/911IncidentResponses/MapServer/0/query?f=json&where=(mapcategory%20%3D%20%27Animal%27)%20OR%20(mapcategory%20%3D%20%27Arrest%27)%20OR%20(mapcategory%20%3D%20%27Disorderly%27)%20OR%20(mapcategory%20%3D%20%27Disturbance%27)%20OR%20(mapcategory%20%3D%20%27FalseAlarm%27)%20OR%20(mapcategory%20%3D%20%27Misc%27)%20OR%20(mapcategory%20%3D%20%27Suspicious%27)%20OR%20(mapcategory%20%3D%20%27Trespass%27)%20OR%20(mapcategory%20%3D%20%27Unsafe%27)%20OR%20(mapcategory%20%3D%20%27Weapon%27)&returnGeometry=true&spatialRel=esriSpatialRelIntersects&geometryType=esriGeometryEnvelope&inSR=102100&outFields=*&outSR=102100')
    crimes[:miscCrimes] = JSON.parse(miscCrimes)["features"]

    Crime.generateCrimes(crimes)
    Crime.categorized_all

  end

  def self.generateCrimes(data)
    data.each do |type, crimes|
      crimes.each do |crime|
        crime = crime["attributes"]
        address = self.formatAddress(crime['addressblock'])
        Crime.find_or_create_by({
            category: type.to_s,
            caseId: crime['caseID'],
            calltype: crime['calltype'],
            callcategory: crime['callcategory'],
            addressblock: address,
            x: crime['X'],
            y: crime['Y']
          }) do |crime|
            coordinates = self.coordsFromAddress(address)
            crime.lat = coordinates["lat"]
            crime.lon = coordinates["lng"]
          end
      end
    end
  end

  def self.categorized_all
    {
      crimesAgainstPersons: Crime.all.where("category LIKE ?", "%crimesAgainstPersons%"),
      propertyCrime: Crime.all.where("category LIKE ?", "%propertyCrime%"),
      drugsAndVice: Crime.all.where("category LIKE ?", "%drugsAndVice%"),
      crisisAndInjury: Crime.all.where("category LIKE ?", "%crisisAndInjury%"),
      trafficCrime: Crime.all.where("category LIKE ?", "%trafficCrime%"),
      miscCrimes: Crime.all.where("category LIKE ?", "%miscCrimes%"),
      uncategorized: Crime.all.where(category: "")
    }
  end

  private
  def self.coordsFromAddress(address)
    data = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json?address=#{self.urlify(address)}&key=#{Rails.application.credentials.dig(:google)[:maps_api_key]}")
    data["results"] ? data["results"][0]["geometry"]["location"] : {}
  end

  def self.urlify(address)
    address.gsub(" ", "+")+"+seattle,+WA"
  end

  def self.formatAddress(address)
    return address.sub('XX', '15')
  end

  def self.clear
    Crime.all.delete_all
  end

end
