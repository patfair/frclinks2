# Copyright 2017 Patrick Fairbank. All Rights Reserved.
# @author pat@patfairbank.com (Patrick Fairbank)
#
# Links for reaching miscellaneous FRC pages.

module FrcLinks
  class Server < Sinatra::Base
    # Redirects to the game documents page.
    get /\/(d|docs?|documents?)(\/(\d+))?/i do
      year = params["captures"][2]
      if year && year != default_year.to_s
        redirect "https://www.firstinspires.org/node/5331"
      else
        redirect "https://www.firstinspires.org/resource-library/frc/competition-manual-qa-system"
      end
    end

    # Redirects to a specific rule in the manual.
    get /\/(d|docs?|documents?)\/([A-Za-z])(\d+)/i do
      rule_type = params["captures"][1].upcase
      rule_number = params["captures"][2]
      redirect "https://frc-qa.firstinspires.org/manual/rule/#{rule_type}/#{rule_number}"
    end

    # Redirects to the Kit of Parts page.
    get /\/(k|kop|kitofparts)/i do
      redirect "https://www.firstinspires.org/robotics/frc/kit-of-parts"
    end

    # Redirects to the Playing Field page.
    get /\/(p|pf|playingfield)/i do
      redirect "https://www.firstinspires.org/robotics/frc/playing-field"
    end

    # Redirects to the Team Updates page.
    get /\/(u|updates)/i do
      redirect "https://www.firstinspires.org/resource-library/frc/competition-manual-qa-system"
    end

    # Redirects to the FRC Blog.
    get /\/(b|blog)/i do
      redirect "https://www.firstinspires.org/robotics/frc/blog"
    end

    # Redirects to the FIRST Forums.
    get /\/(f|forums?)/i do
      redirect "https://forums.usfirst.org"
    end

    # Redirects to the Q&A system.
    get /\/qa?/i do
      redirect "https://frc-qa.firstinspires.org"
    end

    # Redirects to the FRC news page.
    get /\/(n|news)/i do
      redirect "https://www.firstinspires.org/node/4341"
    end

    # Redirects to the FRC calendar.
    get /\/(cal|calendar)/i do
      redirect "https://www.firstinspires.org/robotics/frc/calendar"
    end

    # Redirects to the FRC YouTube channel.
    get /\/(y|youtube)/i do
      redirect "https://www.youtube.com/user/FRCTeamsGlobal"
    end

    # Redirects to the Team/Volunteer/Student Team Information Management System.
    get /\/(t|st|v)ims/i do
      redirect "https://my.firstinspires.org/Dashboard/"
    end

    # Redirects to the The Blue Alliance homepage.
    get /\/tba/i do
      redirect "https://www.thebluealliance.com"
    end
  end
end
