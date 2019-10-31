# Copyright 2017 Patrick Fairbank. All Rights Reserved.
# @author pat@patfairbank.com (Patrick Fairbank)
#
# Links for reaching team information.

module FrcLinks
  class Server < Sinatra::Base
    TEAM_SEARCH_URL = "https://www.firstinspires.org/team-event-search"

    # Redirects to the list of all teams.
    get /^\/(t|teams?)$/i do
      redirect "#{TEAM_SEARCH_URL}#type=teams&sort=number&programs=FRC&year=#{default_year - 1}"
    end

    # Redirects to the FIRST information page for the given team.
    get /^\/(t|teams?)\/(\d+)$/i do
      team = params["captures"][1]
      redirect "#{EVENT_URL}/team/#{team}"
    end

    # Redirects to the list of teams in the given area.
    get /^\/(t|teams?)\/([A-Za-z%20]+)(\/([A-Za-z]+))?$/i do
      country = params["captures"][1]
      stateprov = params["captures"][3]
      url = "#{TEAM_SEARCH_URL}#type=teams&sort=number&programs=FRC&year=#{default_year - 1}&country=#{country}"
      url += "&stateprov=#{stateprov}" if stateprov
      redirect url
    end

    # Redirects to the website for the given team.
    get /^\/(w|website)\/(\d+)$/i do
      team = params["captures"][1]
      team_info = query_team(team)
      website_url = team_info["website"]
      halt(400, "No website found for team #{team}.") if website_url.empty?
      unless website_url.start_with?("http")
        website_url = "http://#{website_url}"
      end
      redirect website_url
    end

    # Redirects to a Google Map of the given team's location.
    get /^\/(m|map)\/(\d+)$/i do
      team = params["captures"][1]
      team_info = query_team(team)
      map_url = "https://www.google.com/maps?q=#{team_info["city"]}+#{team_info["stateProv"]}" +
          "+#{team_info["country"]}"
      redirect map_url
    end

    # Redirects to the The Blue Alliance page for the given team.
    get /^\/tba\/(\d+)$/i do
      team = params["captures"][0]
      redirect "https://www.thebluealliance.com/team/#{team}"
    end

    # Redirects to the Chief Delphi Media page for the given team.
    get /^\/cdm\/(\d+)$/i do
      team = params["captures"][0]
      redirect "https://www.chiefdelphi.com/search?q=tags%3Afrc#{team}%20%23cd-media"
    end

    def query_team(team)
      query = {
        "query" => {
          "query_string" => {
            "query" => "team_number_yearly:#{team} AND profile_year:#{default_year} AND team_type:FRC"
          }
        }
      }.to_json
      response = HTTParty.get("https://frc-api.firstinspires.org/v2.0/#{default_year}/teams?teamNumber=#{team}",
        :headers => { "Authorization" => "Basic #{CheesyCommon::Config.frc_api_token}" })
      team_info = response["teams"][0] rescue nil
      halt(400, "No information found for team #{team}.") if team_info.nil?
      team_info
    end
  end
end
