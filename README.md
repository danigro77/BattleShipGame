## Battleship Game

Ruby 2.2.4 | Rails 4.2.6 | Angular 1.4.0 | Node 5.6.0 | PostgreSQL 9.5.1

#### How to run it locally
1. Clone the [repository](https://github.com/danigro77/BattleShipGame)
    ```
    git clone git@github.com:danigro77/BattleShipGame.git
    ```

2. Change into the new directory
    ```
    cd BattleShipGame
    ```

3. Chreate the database
    * Install Postgres, if you have not already
        ```
        brew install postgresql
        ```

    * Start Postgres
        ```
        pg_ctl -D /usr/local/pgsql/data/ start
        ```

    * Create and fill the database
        ```
        rake db: create
        rake db:setup
        rake db:test:prepare
        ```

    4. Install the gems
        
        ```
        bundle install
        ```
5. Running the Rails server
    
    For now this does not work in RubyMine, so run in the Terminal
    ```
    rails s
    ```
6. Angular
    * Make sure uou have npm and bower installed
        ```
        brew install node
        brew install npm
        npm install -g bower
        ```
    * Install the packages
        ```
        cd angular-client
        npm install
        bower install
        ```
    * Run Grunt server
        ```
        cd angular-client
        grunt serve
        ```
7. Visit: [http://localhost:9000](http://localhost:9000)

