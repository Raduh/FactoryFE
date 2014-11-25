require 'mongo'
include Mongo
require 'json'
require 'time'

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
        
        # remove useless data
        results.each {|r| r.delete "_id"; r.delete "measurements"}

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
        results.each {|r| r.delete "_id"; r.delete "measurements"}

        respond_to do |fmt|
            fmt.json { render :json => results.to_json }
        end
    end

end
