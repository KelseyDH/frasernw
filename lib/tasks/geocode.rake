include Net
    
namespace :pathways do
  task :geocode => :environment do
    Address.all.reject{ |a| a.empty? }.each do |a|
      next if a.latitude != 0.0
      result = JSON.parse( Net::HTTP.get( URI( URI.escape("http://maps.googleapis.com/maps/api/geocode/json?address=#{a.geocode_address} Canada&sensor=false") ) ) )
      if result["status"] != "OK"
        puts "NO results for #{a.geocode_address}"
      else
        latitude = result["results"][0]["geometry"]["location"]["lat"]
        longitude = result["results"][0]["geometry"]["location"]["lng"]
        puts "#{a.geocode_address}: latitude #{latitude}, longitude #{longitude}"
        a.latitude = latitude
        a.longitude = longitude
        a.save
      end
      sleep(1)
    end
  end
end