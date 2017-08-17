class SearchController < ApplicationController
  require 'google/api_client'

  DEVELOPER_KEY = ENV['YOUTUBE_API']
  YOUTUBE_API_SERVICE_NAME = 'youtube'
  YOUTUBE_API_VERSION = 'v3'

  def get_service
    client = Google::APIClient.new(
      :key => DEVELOPER_KEY,
      :authorization => nil,
      :application_name => $PROGRAM_NAME,
      :application_version => '1.0.0'
    )
    youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)
    return client, youtube
  end

  def videos_Search
    client, youtube = get_service
    begin
      search_response = client.execute!(
        :api_method => youtube.search.list,
        :parameters => {
          :part => 'snippet',
          :q => params[:query],
          :maxResults => '50',
          :type => 'video'
        }
      )
      render :json => {:status => 'success', :data => search_response.body}
    rescue Google::APIClient::TransmissionError => e
      puts e.result.body
      render :json => {:status => 'failure', :data => 'Please Try again.'}
    end
  end

  def index
  end
end
