'use strict'

angular.module('battleShipGameApp').service "PlayerService", [ '$http', (http) ->

  @getCurrentPlayer = (data) ->
    http.get '/api/players/current/?player='+ JSON.stringify data

  @saveNewPlayer = (data) ->
    http.post '/api/players/new/?player='+ JSON.stringify data

  @
]
