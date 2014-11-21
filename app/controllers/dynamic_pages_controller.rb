require 'mongo'
require 'json'
include Mongo

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
        $COLL = client['factory_data']['series1']

        resultsCursor = $COLL.find('serialnumber' => serialN)

        results = resultsCursor.to_a
        
        respond_to do |fmt|
            fmt.json { render :json => results.to_json }
        end
    end

    def queryDate
        query = params[:inputDate]
        puts "UNIMPLEMENTED:"
        puts query.class
        puts query

        respond_to do |fmt|
            fmt.json { render :json => "{status: 'not_implemented'}" }
        end
    end

end
