Rincex Scraper
==============

 * Scraper + alternative interface for the Rincex document management system. Indexes one Rincex project.

Status
======

Scraping is working, database is all set up and being populated. Basic interface is displayed and atom feed provided.

 * Better interface (Make use of the tree structure?)

Development Setup
=================
      # Clone the project
      $ bundle install
      # Edit config files in config/
      $ rake db:create
      $ rake db:migrate
      $ rake scrape       # Takes a while, be patient!

      $ rails server