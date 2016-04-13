'use strict'

angular.module('battleShipGameApp').controller("MainCtrl", ['$scope', '$cookieStore', 'PlayerService', 'GameService', 'ErrorHelper', (scope, cookieStore, PlayerService, GameService, ErrorHelper)->
  scope.currentPlayer = cookieStore.get('currentPlayer')

  scope.loggedIn = scope.currentPlayer != undefined
  scope.errorMessage = undefined
  scope.helper = ErrorHelper
  scope.gameView = false

  getOnlinePlayers = ->
    PlayerService.getOnlinePlayers(scope.currentPlayer.id).then (response) ->
      if response.status == 200
        players = response.data['players']
        scope.onlinePlayers = players
    , (errors) ->
      scope.errorMessage = scope.helper.errorMessage(errors)

  if scope.loggedIn
    getOnlinePlayers()

  scope.initPlayers = ->
    if scope.loggedIn
      setInterval ->
        getOnlinePlayers()
      , 5000

  scope.logOut = ->
    PlayerService.playerLogout(scope.currentPlayer.id).then (response) ->
      if response.status == 200
        cookieStore.put('currentPlayer', undefined)
        scope.currentPlayer = undefined
        scope.loggedIn = false
    , (errors) ->
      scope.errorMessage = scope.helper.errorMessage(errors)

  scope.startNewGame = (player2) ->
    GameService.initNewGame(scope.currentPlayer.id, player2.id).then (response) ->
      if response.status == 200
        gameData = response.data['game']
        scope.game = {}
        scope.game.id = gameData['id']
        switch gameData['player1']['id']
          when scope.currentPlayer.id
            scope.game.myGame = gameData['player1']
            scope.game.opponentsGame = gameData['player2']
          else
            scope.game.myGame = gameData['player2']
            scope.game.opponentsGame = gameData['player1']

        scope.game.myTurn = gameData['current_player_id'] == scope.currentPlayer.id
        scope.gameView = true

  scope.$watch 'currentPlayer', (newVal, oldVal) ->
    if newVal != oldVal && newVal != undefined
      scope.loggedIn = true

  scope.$watch 'loggedIn', (newVal, oldVal) ->
    if newVal != oldVal && newVal != undefined && newVal
      getOnlinePlayers()
])
