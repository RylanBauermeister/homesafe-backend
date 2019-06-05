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
    Crime.all

  end

  def self.generateCrimes(data)
    results = []
    data.each do |type, crimes|
      crimes.each do |crime|
        crime = crime["attributes"]
        results << Crime.find_or_create_by({
            caseId: crime['caseID'],
            calltype: crime['calltype'],
            callcategory: crime['callcategory'],
            addressblock: self.formatAddress(crime['addressblock']),
            x: crime['X'],
            y: crime['Y']
          })
      end
    end
  end

  def self.formatAddress(address)
    xs = address.match(/^(\d+)(X+)/)
    if xs
      zeroes = self.numZeroes(xs[2].length)
      return address.sub('XX', '15')
    end
    address
  end

  def self.clear
    Crime.all.delete_all
  end

  private
  def self.numZeroes(num)
    result = ""
    num.times do
      result = result + "0"
    end
    result
  end
end
