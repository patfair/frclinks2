# Copyright 2017 Patrick Fairbank. All Rights Reserved.
# @author pat@patfairbank.com (Patrick Fairbank)
#
# The main class of the FRCLinks server.

require "cheesy-common"
require "httparty"
require "pathological"
require "sinatra/base"

require "event_links"
require "misc_links"
require "team_links"

module FrcLinks
  class Server < Sinatra::Base
    EVENTS_FILE = "events.json"

    not_found do
      instructions
    end

    get "/" do
      instructions
    end

    # Fetches the list of events for the current year and caches it in a local file.
    get "/reindex_events" do
      response = HTTParty.get("https://frc-api.firstinspires.org/v2.0/#{default_year}/events",
        :headers => { "Authorization" => "Basic #{CheesyCommon::Config.frc_api_token}" })

      events = []
      response["Events"].each do |event|
        next if ["ChampionshipDivision", "OffSeasonWithAzureSync"].include?(event["type"])
        next if event["name"].start_with?("I choose not to attend")
        name = event["name"]
        name.gsub!(/ Regional/, "")
        name.gsub!(/ District/, "")
        name.gsub!(/ Event/, "")
        name.gsub!(/Festival de Robotique - /, "")
        name.gsub!(/ sponsored by.*/, "")
        name.gsub!(/ \(.*/, "")
        name.gsub!(/ \*.*/, "")
        events << { :code => event["code"].downcase, :name => name, :type => event["type"] }
      end

      events.sort! do |a, b|
        if a[:type] == b[:type]
          a[:name] <=> b[:name]
        else
          b[:type] <=> a[:type]
        end
      end

      File.open(EVENTS_FILE, "w") { |file| file.puts(JSON.pretty_generate(events)) }
      "Indexed #{events.size} events."
    end

    get "/robots.txt" do
      content_type "text/plain"
      "User-agent: *\nDisallow: /"
    end

    def default_year
      year = Time.now.year
      if Time.now.month >= 9
        year += 1
      end
      year
    end

    # Renders a page with instructions on how to use FRCLinks.
    def instructions
      @events = JSON.parse(File.read(EVENTS_FILE))
      erb :instructions
    end
  end
end
