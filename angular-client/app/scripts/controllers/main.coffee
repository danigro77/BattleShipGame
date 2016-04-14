'use strict'

angular.module('battleShipGameApp').controller("MainCtrl", ['$scope', '$cookieStore', 'PlayerService', 'GameService', 'ErrorHelper', (scope, cookieStore, PlayerService, GameService, ErrorHelper)->
  scope.currentPlayer = cookieStore.get('currentPlayer')
  scope.currentGameId = cookieStore.get('currentGame')


  scope.errorMessage = undefined
  scope.helper = ErrorHelper

  setViews = ->
    if scope.currentGameId
      scope.gameView = scope.currentGameId != undefined
    scope.loggedIn = scope.currentPlayer != undefined
    scope.playerView = scope.loggedIn && scope.currentGameId == undefined
    console.log scope

#  PLAYERS
#  ================================
  getOnlinePlayers = ->
    if scope.currentPlayer == undefined
      scope.currentPlayer = cookieStore.get('currentPlayer')
    PlayerService.getOnlinePlayers(scope.currentPlayer.id).then (response) ->
      if response.status == 200
#        scope.playerView = true
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
        checkForGameInvite()
    , 5000

  scope.logOut = ->
    PlayerService.playerLogout(scope.currentPlayer.id).then (response) ->
      if response.status == 200
        cookieStore.remove('currentPlayer')
        cookieStore.remove('currentGame')
        scope.currentPlayer = undefined
        scope.loggedIn = false
        scope.gameView = false
        scope.playerView = false
    , (errors) ->
      scope.errorMessage = scope.helper.errorMessage(errors)

#  GAMES
#  ================================
  checkForGameInvite = ->
    GameService.newGameInvite(scope.currentPlayer.id).then (response) ->
      if response.status == 200
        cookieStore.put('currentGame', {id: response.data['games'][0]})
        scope.currentGameId = cookieStore.get('currentGame')
        getGame(response.data['games'][0])
    , (errors) ->
      scope.errorMessage = scope.helper.errorMessage(errors)

  cleanGameData = (gameData) ->
    if gameData.paused
      cookieStore.remove('currentGame')
      scope.gameView = false
    else
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

  updateGame = ->
    setInterval ->
      if !scope.currentGameId #TODO: find and fix bug
        scope.currentGameId = cookieStore.get('currentGame')
      if scope.currentGameId && scope.gameView && scope.loggedIn
        getGame(scope.currentGameId.id)
    , 5000

  getGame = (id) ->
    if id != undefined
      GameService.getGame(id).then (response) ->
        scope.playerView = false
        if response.status == 200
          cleanGameData(response.data['game'])
      , (errors) ->
        scope.errorMessage = scope.helper.errorMessage(errors)

  scope.startNewGame = (player2) ->
    GameService.initNewGame(scope.currentPlayer.id, player2.id).then (response) ->
      if response.status == 200
        scope.playerView = false
        cleanGameData(response.data['game'])
    , (errors) ->
      scope.errorMessage = scope.helper.errorMessage(errors)

#  WATCH
#  ================================

  scope.$watch 'currentGame', (newVal, oldVal) ->
    if newVal != oldVal && newVal != undefined
      scope.gameView = true
    else if newVal == undefined
      scope.gameView = false
      if scope.loggedIn && !scope.gameView
        getOnlinePlayers()

  scope.$watch 'currentPlayer', (newVal, oldVal) ->
    if newVal != oldVal && newVal != undefined
      scope.loggedIn = true

  scope.$watch 'loggedIn', (newVal, oldVal) ->
    if newVal != oldVal && newVal != undefined && newVal
      getOnlinePlayers()
      scope.playerView = newVal && !scope.gameView

  scope.$watch 'gameView', (newVal, oldVal) ->
    if !newVal && scope.loggedIn
      getOnlinePlayers()
      scope.playerView = true
    else if newVal
      updateGame()

  setViews()
])
