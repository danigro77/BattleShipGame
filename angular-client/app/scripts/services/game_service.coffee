'use strict'

angular.module('battleShipGameApp').service "GameService", [ '$http', (http) ->

  @getGame = (id) ->
    http.get '/api/games/current/'+ id

  @initNewGame = (player1Id, player2Id) ->
    http.post '/api/games/new/'+ player1Id + '/' + player2Id

  @
]
