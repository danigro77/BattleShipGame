'use strict'

angular.module('battleShipGameApp').controller("MainCtrl", ['$scope', '$cookieStore', 'PlayerService', 'GameService', 'ErrorHelper', (scope, cookieStore, PlayerService, GameService, ErrorHelper)->
  scope.currentPlayer = cookieStore.get('currentPlayer')
  scope.currentGameId = cookieStore.get('currentGame')

  scope.errorMessage = undefined
  scope.helper = ErrorHelper
  scope.loading = false

  setViews = (player, game, stats) ->
    scope.playerView = player && scope.loggedIn if player != undefined
    scope.gameView = game && scope.loggedIn if game != undefined
    scope.statsView = stats && scope.loggedIn if stats != undefined

  setNoView = ->
    setViews(false, false, false)
  setPlayerView = ->
    setViews(true, false, false)
  setGameView = ->
    setViews(false, true, false)
  setStatsView = ->
    setViews(false, false, true)

  initViews = ->
    scope.loggedIn = scope.currentPlayer != undefined
    game = scope.loggedIn && scope.currentGameId != undefined && !scope.currentGameId.won
    stats = scope.loggedIn && scope.currentGameId != undefined && scope.currentGameId.won
    player = scope.loggedIn && !game && !stats
    if player
      getOnlinePlayers()
    else
      getGame(scope.currentGameId.id)

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
        scope.loading = false
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
        setNoView()
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
          scope.loading = true
          updateGame()
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
    scope.currentGameId = undefined
    scope.currentGame = undefined
    getOnlinePlayers()
    setPlayerView()
    scope.loading = false
    getPlayerData()

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
      if scope.currentGame
        setGameView()
    scope.loading = false


  updateGame = ->
    if gameViewOnly()
      setInterval ->
        if scope.currentGameId && (scope.gameView || scope.statsView) && scope.loggedIn
          getGame(scope.currentGameId.id)
      , 5000

  statsDataSetup = (data) ->
    scope.gameStats = data
    cookieStore.put('currentGame', {id: data.id, won: true})
    setStatsView()
    scope.loading = false

  getGame = (id) ->
    if id != undefined && scope.gameStats == undefined
      GameService.getGame(id).then (response) ->
        setNoView()
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
    if newVal != undefined && oldVal =! newVal
      if newVal.won
        setStatsView()
      else
        setNoView()
        scope.loading = true
        updateGame()
        getGame(newVal)
    else if newVal != oldVal
      cookie = cookieStore.get('currentGame')
      if cookie != undefined
        getGame(cookie.id)
        updateGame()
      else
        getPlayerData()
        getOnlinePlayers()
        setPlayerView()

  scope.$watch 'currentPlayer', (newVal, oldVal) ->
    if newVal != oldVal && newVal != undefined
      scope.loggedIn = true

  scope.$watch 'loggedIn', (newVal, oldVal) ->
    if newVal != oldVal && newVal != undefined && newVal
      switchToPlayer = newVal && playerViewOnly()
      if switchToPlayer
        setPlayerView()
      else
        setViews(player, undefined , undefined )

  scope.$watch 'backToPlayerView', (newVal, oldVal) ->
    if newVal != undefined && newVal && newVal != oldVal
      getPlayerData()
      setPlayerView()
      scope.backToPlayerView = undefined

  initViews()
])
