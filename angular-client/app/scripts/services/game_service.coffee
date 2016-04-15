'use strict'

angular.module('battleShipGameApp').service "GameService", [ '$http', (http) ->

  @getGame = (id) ->
    http.get '/api/games/current/'+ id
    
  @newGameInvite = (playerId) ->
    http.get '/api/games/check_invites/' + playerId

  @initNewGame = (player1Id, player2Id) ->
    http.post '/api/games/new/'+ player1Id + '/' + player2Id

  @pauseGame = (id) ->
    http.put '/api/games/pause/'+ id

  @
]
