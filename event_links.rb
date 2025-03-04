# Copyright 2017 Patrick Fairbank. All Rights Reserved.
# @author pat@patfairbank.com (Patrick Fairbank)
#
# Links for reaching event information.

module FrcLinks
  class Server < Sinatra::Base
    EVENT_CODE_REGEX = "([A-Za-z0-9]{2,})"
    EVENT_URL = "https://frc-events.firstinspires.org"

    # Redirects to the team list for the given event.
    get /\/(e|event)\/#{EVENT_CODE_REGEX}(\/(\d+))?/i do
      event = params["captures"][1]
      year = params["captures"][3] || default_year
      redirect "#{EVENT_URL}/#{year}/#{event}"
    end

    # Redirects to the qualification schedule and results for the given event.
    get /\/(e|event)\/(q|quals?|qualifications?|s|m)\/#{EVENT_CODE_REGEX}(\/(\d+))?/i do
      event = params["captures"][2]
      year = params["captures"][4] || default_year
      redirect "#{EVENT_URL}/#{year}/#{event}/qualifications"
    end

    # Redirects to the playoff schedule and results for the given event.
    get /\/(e|event)\/(p|playoffs?|e|elims?|eliminations?)\/#{EVENT_CODE_REGEX}(\/(\d+))?/i do
      event = params["captures"][2]
      year = params["captures"][4] || default_year
      redirect "#{EVENT_URL}/#{year}/#{event}/playoffs"
    end

    # Redirects to the qualification rankings for the given event.
    get /\/(e|event)\/(r|rankings?|standings?)\/#{EVENT_CODE_REGEX}(\/(\d+))?/i do
      event = params["captures"][2]
      year = params["captures"][4] || default_year
      redirect "#{EVENT_URL}/#{year}/#{event}/rankings"
    end

    # Redirects to the awards for the given event.
    get /\/(e|event)\/(a|awards?|standings?)\/#{EVENT_CODE_REGEX}(\/(\d+))?/i do
      event = params["captures"][2]
      year = params["captures"][4] || default_year
      redirect "#{EVENT_URL}/#{year}/#{event}/awards"
    end

    # Redirects to the agenda for the given event.
    get /\/(e|event)\/(g|agenda)\/#{EVENT_CODE_REGEX}(\/(\d+))?/i do
      event = params["captures"][2]
      year = params["captures"][4] || default_year
      redirect "http://firstinspires.org/sites/default/files/uploads/frc/#{year}-events/#{year}_" +
          "#{event.upcase}_Agenda.pdf"
    end

    # Redirects to the The Blue Alliance page for the given event.
    get /\/(e|event)\/(t|tba)\/#{EVENT_CODE_REGEX}(\/(\d+))?/i do
      event = params["captures"][2]
      year = params["captures"][4] || default_year
      redirect "https://www.thebluealliance.com/event/#{year}#{event}"
    end

    # Redirects to the district ranking page for the given district.
    get /\/(dr|districtrankings?)\/([A-Za-z]+)(\/(\d+))?/i do
      district = params["captures"][1]
      year = params["captures"][3] || default_year
      redirect "#{EVENT_URL}/#{year}/district/#{district}"
    end

    # Redirects to the global regional advancement ranking page.
    get /\/(ra|regionaladvancement?)/i do
      redirect "#{EVENT_URL}/ra/"
    end

    # Redirects to the regional advancement ranking page for the given regional event.
    get /\/(ra|regionaladvancement?)\/#{EVENT_CODE_REGEX}/i do
      event = params["captures"][1]
      redirect "#{EVENT_URL}/ra/regional/#{event.upcase}"
    end

    # Redirects to the Kickoff page.
    get /\/(ko|kickoff)/i do
      redirect "https://www.firstinspires.org/robotics/frc/kickoff"
    end

    # Redirects to the event list page for the given year.
    get /\/(e|events|r|regionals)(\/(\d+))?/i do
      year = params["captures"][2] || default_year
      redirect "#{EVENT_URL}/#{year}/events/eventlist"
    end

    # Redirects to the Championship website.
    get /\/(c|cmp|championship)/i do
      redirect "https://www.firstchampionship.org"
    end
  end
end
