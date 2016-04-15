'use strict'

angular.module('battleShipGameApp').service "PlayerService", [ '$http', (http) ->

  @getCurrentPlayer = (data) ->
    http.get '/api/players/current/?player='+ JSON.stringify data

  @getOnlinePlayers = (playerId) ->
    http.get '/api/players/online/' + playerId

  @saveNewPlayer = (data) ->
    http.post '/api/players/new/?player='+ JSON.stringify data

  @exitGame = (playerId) ->
    http.put 'api/players/finish_game/' + playerId
    
  @playerLogout = (playerId) ->
    http.put 'api/players/logout/' + playerId

  @
]
