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

    def handleQuery
        respond_to do |fmt|
            fmt.json { render :json => {message: "success"} }
        end
    end
end
