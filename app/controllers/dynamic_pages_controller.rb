require 'mongo'
include Mongo
require 'json'
require 'time'
require 'open-uri'

class DynamicPagesController < ApplicationController
    def home
        render :file => 'app/views/upload/uploadfile'
    end

    def uploadFile
        post = DataFile.save(params[:datafile])
        render :text => "File has been uploaded successfully"
    end

    def queryPage
    end

    def querySerial
        serialN = params[:inputSerial]

        client = MongoClient.from_uri(ENV['MONGO_URI']) 
        coll = client['factory_data']['series1']  # collection
        resultsCursor = coll.find('serialnumber' => serialN)
        results = resultsCursor.to_a
        
        results.each do |r|
            # remove useless data
            r.delete "_id"
            # add location info
            place = toLocation r["location"]
            r["place"] = place if place != nil
            # add nicely formatted date
            r["pretty_date"] = toDateStr r["startTime"]
        end

        respond_to do |fmt|
            fmt.json { render :json => results.to_json }
        end
    end

    def queryDate
        fmt = "%m/%d/%Y"
        _start = Date.strptime(params[:startDate], fmt).to_time.to_i
        _end = Date.strptime(params[:endDate], fmt).to_time.to_i

        client = MongoClient.from_uri(ENV['MONGO_URI']) 
        coll = client['factory_data']['series1'] # collection
        resultsCursor =
            coll.find('startTime' => {'$gte' => _start, '$lte' => _end})
        results = resultsCursor.to_a
        
        # remove useless data
        results.each do |r|
            r.delete "_id"
            r.delete "measurements"
            r["pretty_date"] = toDateStr r["startTime"]
        end

        respond_to do |fmt|
            fmt.json { render :json => results.to_json }
        end
    end

    private
    # helper method TODO: move in helpers
    # gets to coordinates, returns a string name
    def toLocation location
        return "" if (location == nil)
        lat = location["latitude"]
        lng = location["longitude"]

        url = "http://nominatim.openstreetmap.org/reverse?format=json&lat=#{lat}&lon=#{lng}"
        content = open(url).read
        dataJSON = JSON.parse(content)
        return dataJSON["display_name"]
    end

    # convert timestamp to date string
    def toDateStr timestamp
        d = Date.strptime(timestamp.to_s, "%s")
        d.strftime("%e %B %Y")
    end
end
