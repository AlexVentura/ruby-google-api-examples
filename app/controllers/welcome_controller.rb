class WelcomeController < ApplicationController
  def index
    google_service = GoogleApisService::Sheets.new

    #render json: { google_service: google_service }, status: 200
    #my_access_token = google_service.service.request_options.authorization.access_token

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: google_service }
    end
  end

  def drive
    drive_service = GoogleApisService::Drive.new
    @data = drive_service.list_files
    #drive_service.download_file
  end

  def download_file
    file_id = params[:file_id] || ''

    drive_service = GoogleApisService::Drive.new
    file_name = drive_service.download_file(file_id)

    if file_name
      send_file "tmp/#{file_name}.xlsx",
        type: "application/xlsx", filename: "#{file_name}.xlsx", disposition: 'inline'
    end

    #redirect_to welcome_drive_path
  end

  def server_side
    auth = "Bearer 'ya29.c.DmybJXXZzegGsv0Q3N-1P1DkHWOBE9lzz4WA9A-sy9fXTw'"
    url = URI.parse('https://docs.google.com/spreadsheets/d/e/2PACX-1vTWCKT5lY4Vp8K6lsT4l5UurXaDb6kV6SkaSW9OBMN58N1GTVgaagnI9OVOH6vGjOh01eZcpgmY4fH4/pubhtml')
    #url = URI.parse('https://docs.google.com/spreadsheets/d/e/2PACX-1vT3V_RewL5fHc3pMOJIN8Xx1BOV9Bh1XHUAhvz9jhFgiLK0KDxhRRpF3dHIygPJqBB_qYJlcW9o8HDc/pubhtml')
    #url = URI.parse('https://docs.google.com/spreadsheets/d/e/2PACX-1vQ9YtDaxRjZR3KTjcCBRy-6jttoKItk-KG1HLQVQssTYgeu1Tv0rWopbOSIBOSmwLQ4RenIRKyrRU4V/pubhtml')
    #url = URI.parse('https://docs.google.com/spreadsheets/d/e/2PACX-1vRmPTFlxE4_7GqQQ2unAd6bX4HttQ_nlMtVWDWceKcAQLLLc0efJQ8xN__ndRpYdfbYgsSTMkXTAVuS/pubhtml')
    #url = URI.parse('https://docs.google.com/spreadsheets/d/e/2PACX-1vRp73rjeZ5QKgi10XWcUawaeyjF-WdTUkM6su7goX1RzvmLq106g5onNzL-0nJt0jI7WtlanjMz2omL/pubhtml')

    my_request = Net::HTTP::Get.new(url.to_s, {})
    #my_request.authorization = "Token access_token=#{auth}"

    my_response = Net::HTTP.start(url.host, url.port, :use_ssl => true) do |http|
      http.request(my_request)
    end
    #end.response.body
    my_response.body
    @final_data = setup_assets_links(my_response.body)

    render layout: false
  end

  def demo_link
    google_service = GoogleSheets.new
    @response = google_service.query_sheet
  end

  private

  def setup_assets_links(data)
    google_domain = 'https://docs.google.com'

    #data.delete!("\r\n\\")
    data.gsub!("'/static/", "'" + google_domain + "/static/")
    data
  end
end
