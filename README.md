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

License
=======
Copyright Dave Barker 2010 and released under the GPL.

     This program is free software: you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
     the Free Software Foundation, either version 3 of the License, or
     (at your option) any later version.

     This program is distributed in the hope that it will be useful,
     but WITHOUT ANY WARRANTY; without even the implied warranty of
     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
     GNU General Public License for more details.

     You should have received a copy of the GNU General Public License
     along with this program.  If not, see <http://www.gnu.org/licenses/>.