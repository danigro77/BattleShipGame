'use strict'

angular.module('battleShipGameApp').controller("MainCtrl", ['$scope', '$cookieStore', 'PlayerService', 'GameService', 'ErrorHelper', (scope, cookieStore, PlayerService, GameService, ErrorHelper)->
  scope.currentPlayer = cookieStore.get('currentPlayer')
  scope.currentGameId = cookieStore.get('currentGame')

  scope.loggedIn = scope.currentPlayer != undefined
  scope.gameView = scope.currentGameId != undefined
  scope.playerView = scope.loggedIn && !scope.gameView
  scope.errorMessage = undefined
  scope.helper = ErrorHelper

#  PLAYERS
#  ================================
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
    setInterval ->
      if scope.loggedIn && !scope.gameView
        getOnlinePlayers()
    , 5000

  scope.logOut = ->
    PlayerService.playerLogout(scope.currentPlayer.id).then (response) ->
      if response.status == 200
        cookieStore.remove('currentPlayer')
        scope.currentPlayer = undefined
        scope.loggedIn = false
    , (errors) ->
      scope.errorMessage = scope.helper.errorMessage(errors)

#  GAMES
#  ================================
  cleanGameData = (gameData) ->
    scope.currentGame = {}
    scope.currentGame.id = gameData['id']
    switch gameData['player1']['id']
      when scope.currentPlayer.id
        scope.currentGame.myGame = gameData['player1']
        scope.currentGame.opponentsGame = gameData['player2']
      else
        scope.currentGame.myGame = gameData['player2']
        scope.currentGame.opponentsGame = gameData['player1']
    switch gameData.boards[0]['player_id']
      when scope.currentPlayer.id
        scope.currentGame.myGame.board = gameData.boards[0]
        scope.currentGame.opponentsGame.board = gameData.boards[1]
      else
        scope.currentGame.myGame.board = gameData.boards[1]
        scope.currentGame.opponentsGame.board = gameData.boards[0]
    scope.currentGame.myTurn = gameData['current_player_id'] == scope.currentPlayer.id

  getGame = (id) ->
    GameService.getGame(id).then (response) ->
      if response.status == 200
        cleanGameData(response.data['game'])
    , (errors) ->
      scope.errorMessage = scope.helper.errorMessage(errors)

  scope.startNewGame = (player2) ->
    GameService.initNewGame(scope.currentPlayer.id, player2.id).then (response) ->
      if response.status == 200
        cleanGameData(response.data['game'])
    , (errors) ->
      scope.errorMessage = scope.helper.errorMessage(errors)

#  WATCH
#  ================================
  scope.$watch 'currentGameId', (newVal, oldVal) ->
    if (newVal != oldVal && newVal != undefined)
      getGame(newVal.id)
    else if oldVal != undefined
      getGame(oldVal.id)

  scope.$watch 'currentGame', (newVal, oldVal) ->
    if newVal != oldVal && newVal != undefined
      cookieStore.put('currentGame', {id: scope.currentGame.id})
      scope.gameView = true
    else if newVal == undefined
      scope.gameView = false
      getOnlinePlayers()

  scope.$watch 'currentPlayer', (newVal, oldVal) ->
    if newVal != oldVal && newVal != undefined
      scope.loggedIn = true

  scope.$watch 'loggedIn', (newVal, oldVal) ->
    if newVal != oldVal && newVal != undefined && newVal
      getOnlinePlayers()

  scope.$watch 'gameView', (newVal, oldVal) ->
    if !newVal
      getOnlinePlayers()


])
