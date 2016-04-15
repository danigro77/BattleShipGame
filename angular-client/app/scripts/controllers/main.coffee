'use strict'

angular.module('battleShipGameApp').controller("MainCtrl", ['$scope', '$cookieStore', 'PlayerService', 'GameService', 'ErrorHelper', (scope, cookieStore, PlayerService, GameService, ErrorHelper)->
  scope.currentPlayer = cookieStore.get('currentPlayer')
  scope.currentGameId = cookieStore.get('currentGame')

  scope.errorMessage = undefined
  scope.helper = ErrorHelper
  scope.loading = false

  setViews = (player, game, stats) ->
    scope.playerView = player if player != undefined
    scope.gameView = game if game != undefined
    scope.statsView = stats if stats != undefined

  initViews = ->
    scope.loggedIn = scope.currentPlayer != undefined
    game = scope.loggedIn && scope.currentGameId != undefined && !scope.currentGameId.won
    stats = scope.loggedIn && scope.currentGameId != undefined && scope.currentGameId.won
    player = scope.loggedIn && !game && !stats
    setViews(player, game, stats)

  playerViewOnly = ->
    scope.loggedIn && !scope.gameView && !scope.statsView
  gameViewOnly = ->
    scope.loggedIn && !scope.playerView && !scope.statsView
  statsViewOnly = ->
    scope.loggedIn && !scope.playerView && !scope.gameView

#  PLAYERS
#  ================================
  getOnlinePlayers = ->
    if scope.currentPlayer == undefined
      scope.currentPlayer = cookieStore.get('currentPlayer')
    PlayerService.getOnlinePlayers(scope.currentPlayer.id).then (response) ->
      if response.status == 200
        players = response.data['players']
        scope.onlinePlayers = players
    , (errors) ->
      scope.errorMessage = scope.helper.errorMessage(errors)

  scope.initPlayers = ->
    getPlayerData()

  getPlayerData = ->
    setInterval ->
      if !scope.loading && playerViewOnly()
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
        scope.loading = false
        setViews(false, false, false)
    , (errors) ->
      scope.errorMessage = scope.helper.errorMessage(errors)

#  GAMES
#  ================================
  checkForGameInvite = ->
    if playerViewOnly() && !scope.loading
      GameService.newGameInvite(scope.currentPlayer.id).then (response) ->
        if response.status == 200
          cookieStore.put('currentGame', {id: response.data['games'][0]})
          scope.currentGameId = cookieStore.get('currentGame')
          getGame(response.data['games'][0])
      , (errors) ->
        scope.errorMessage = scope.helper.errorMessage(errors)

  setPlayer = (me, opponent) ->
    scope.currentGame.myGame = me
    scope.currentGame.opponentsGame = opponent

  setBoards = (mine, opponets) ->
    scope.currentGame.myGame.board = mine
    scope.currentGame.opponentsGame.board = opponets

  pausedGame = ->
    cookieStore.remove('currentGame')
    setViews(true, false, false)

  cleanGameData = (gameData) ->
    if gameData.paused
      pausedGame()
    else
      scope.currentGame = {}
      scope.currentGame.id = gameData['id']
      switch gameData['player1']['id']
        when scope.currentPlayer.id
          setPlayer(gameData['player1'], gameData['player2'])
        else
          setPlayer(gameData['player2'], gameData['player1'])
      switch gameData.boards[0]['player_id']
        when scope.currentPlayer.id
          setBoards(gameData.boards[0], gameData.boards[1])
        else
          setBoards(gameData.boards[1], gameData.boards[0])
      scope.currentGame.myTurn = gameData['current_player_id'] == scope.currentPlayer.id
    scope.loading = false
    setViews(false, true, false)

  updateGame = ->
    if gameViewOnly()
      setInterval ->
        if !scope.currentGameId #TODO: find and fix bug
          scope.currentGameId = cookieStore.get('currentGame')
        if scope.currentGameId && (scope.gameView || scope.statsView) && scope.loggedIn
          getGame(scope.currentGameId.id)
      , 5000

  statsDataSetup = (data) ->
    scope.gameStats = data
    cookieStore.put('currentGame', {id: data.id, won: true})
    setViews(false, false, true)
    scope.loading = false

  getGame = (id) ->
    if id != undefined && scope.gameStats == undefined
      GameService.getGame(id).then (response) ->
        setViews(false, false, false)
        if response.status == 200
          if response.data['game'] == undefined
            statsDataSetup(response.data['stats'])
          else
            cleanGameData(response.data['game'])
      , (errors) ->
        scope.errorMessage = scope.helper.errorMessage(errors)

  scope.startNewGame = (player2) ->
    scope.playerView = false
    scope.loading = true
    GameService.initNewGame(scope.currentPlayer.id, player2.id).then (response) ->
      if response.status == 200
        cookieStore.put('currentGame', {id: response.data['game'].id})
        scope.currentGameId = cookieStore.get('currentGame')
        scope.loading = false
        cleanGameData(response.data['game'])
        updateGame()
    , (errors) ->
      scope.errorMessage = scope.helper.errorMessage(errors)

#  WATCH
#  ================================
  scope.$watch 'currentGameId', (newVal, oldVal) ->
    if newVal != undefined && newVal.won && oldVal =! newVal
      setViews(false, false, true)

  scope.$watch 'currentGame', (newVal, oldVal) ->
    if newVal != oldVal && newVal != undefined
      setViews(false, true, false)
    else if newVal == undefined
      setViews(true, false, false)

  scope.$watch 'currentPlayer', (newVal, oldVal) ->
    if newVal != oldVal && newVal != undefined
      scope.loggedIn = true

  scope.$watch 'loggedIn', (newVal, oldVal) ->
    if newVal != oldVal && newVal != undefined && newVal
      player = newVal && playerViewOnly()
      if player
        setViews(player, !player, !player)
      else
        setViews(player, undefined , undefined )


  scope.$watch 'gameView', (newVal, oldVal) ->
    if !newVal && scope.loggedIn
      if scope.currentGameId && !scope.statsView
        getGame(scope.currentGameId.id)
        setViews(false, true, false)
      getOnlinePlayers()
      setViews(!scope.statsView, false, scope.statsView)
    else if newVal
      updateGame()

  scope.$watch 'backToPlayerView', (newVal, oldVal) ->
    if newVal != undefined && newVal && newVal != oldVal
      getPlayerData()
      setViews(true, false, false)
      scope.backToPlayerView = undefined

  initViews()
])
