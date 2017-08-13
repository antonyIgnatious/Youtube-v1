class SearchController < ApplicationController

  require 'google/api_client'
  

  # Set DEVELOPER_KEY to the API key value from the APIs & auth > Credentials
  # tab of
  # {{ Google Cloud Console }} <{{ https://cloud.google.com/console }}>
  # Please ensure that you have enabled the YouTube Data API for your project.
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
          :maxResults => '50'
        }
      )

      videos = []
      channels = []
      playlists = []
      response_data = []
      # p search_response.to_json
      # Add each result to the appropriate list, and then display the lists of
      # matching videos, channels, and playlists.
      search_response.data.items.each do |search_result|
        case search_result.id.kind
          when 'youtube#video'
            videos << "#{search_result.snippet.title} (#{search_result.id.videoId})"
            response_data << { :title => search_result.snippet.title, 
                              :videoid => search_result.id.videoId}
          when 'youtube#channel'
            channels << "#{search_result.snippet.title} (#{search_result.id.channelId})"
          when 'youtube#playlist'
            playlists << "#{search_result.snippet.title} (#{search_result.id.playlistId})"
        end
      end
      puts response_data.to_json
      puts "Videos:\n", videos, "\n"
      puts "Channels:\n", channels, "\n"
      puts "Playlists:\n", playlists, "\n"
    rescue Google::APIClient::TransmissionError => e
      puts e.result.body
    end
  end
end
