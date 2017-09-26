# Copyright 2017 Patrick Fairbank. All Rights Reserved.
# @author pat@patfairbank.com (Patrick Fairbank)
#
# Links for reaching team information.

module FrcLinks
  class Server < Sinatra::Base
    TEAM_SEARCH_URL = "https://www.firstinspires.org/team-event-search"

    # Redirects to the list of all teams.
    get /^\/(t|teams?)$/ do
      redirect "#{TEAM_SEARCH_URL}#type=teams&sort=number&programs=FRC&year=#{default_year - 1}"
    end

    # Redirects to the FIRST information page for the given team.
    get /^\/(t|teams?)\/(\d+)$/ do
      team = params["captures"][1]
      redirect "#{TEAM_SEARCH_URL}/team?program=FRC&year=#{default_year}&number=#{team}"
    end

    # Redirects to the list of teams in the given area.
    get /^\/(t|teams?)\/([A-Za-z%20]+)(\/([A-Za-z]+))?$/ do
      country = params["captures"][1]
      stateprov = params["captures"][3]
      url = "#{TEAM_SEARCH_URL}#type=teams&sort=number&programs=FRC&year=#{default_year}&country=#{country}"
      url += "&stateprov=#{stateprov}" if stateprov
      redirect url
    end

    # Redirects to the website for the given team.
    get /^\/(w|website)\/(\d+)$/ do
      team = params["captures"][1]
      team_info = query_team(team)
      website_url = team_info["team_web_url"]
      halt(400, "No website found for team #{team}.") if website_url.nil?
      unless website_url.start_with?("http")
        website_url = "http://#{website_url}"
      end
      redirect website_url
    end

    # Redirects to a Google Map of the given team's location.
    get /^\/(m|map)\/(\d+)$/ do
      team = params["captures"][1]
      team_info = query_team(team)
      map_url = "https://www.google.com/maps?q=#{team_info["team_city"]}+#{team_info["team_stateprov"]}" +
          "+#{team_info["team_country"]}"
      if ["Canada", "USA", "United Kingdom"].include?(team_info["team_country"])
        map_url += "+#{team_info["team_postalcode"]}"
      end
      redirect map_url
    end

    # Redirects to the The Blue Alliance page for the given team.
    get /^\/tba\/(\d+)$/ do
      team = params["captures"][0]
      redirect "https://www.thebluealliance.com/team/#{team}"
    end

    # Redirects to the Chief Delphi Media page for the given team.
    get /^\/cdm\/(\d+)$/ do
      team = params["captures"][0]
      redirect "http://www.chiefdelphi.com/media/photos/tags/frc#{team}"
    end

    def query_team(team)
      query = {
        "query" => {
          "query_string" => {
            "query" => "team_number_yearly:#{team} AND profile_year:#{default_year} AND team_type:FRC"
          }
        }
      }.to_json
      response = HTTParty.get("http://es01.usfirst.org/teams/_search?size=1&source=#{URI.encode(query)}")
      team_info = response["hits"]["hits"][0]["_source"] rescue nil
      halt(400, "No information found for team #{team}.") if team_info.nil?
      team_info
    end
  end
end
