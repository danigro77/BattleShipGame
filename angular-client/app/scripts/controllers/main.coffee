'use strict'

angular.module('battleShipGameApp').controller("MainCtrl", ['$scope', '$cookieStore', 'PlayerService', 'ErrorHelper', (scope, cookieStore, PlayerService, ErrorHelper)->
  scope.currentPlayer = cookieStore.get('currentPlayer')

  scope.loggedIn = scope.currentPlayer != undefined
  scope.errorMessage = undefined
  scope.helper = ErrorHelper

  getOnlinePlayers = ->
    PlayerService.getOnlinePlayers(scope.currentPlayer.id).then (response) ->
      if response.status == 200
        players = response.data['players']
        for p in players
          if p.id == scope.currentPlayer.id
            players.splice(players.indexOf(p), 1)
            break
        scope.onlinePlayers = players
    , (errors) ->
      scope.errorMessage = scope.helper.errorMessage(errors)

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
    alert "NEW GAME!!"

  scope.$watch 'currentPlayer', (newVal, oldVal) ->
    if newVal != oldVal && newVal != undefined
      scope.loggedIn = true

  scope.$watch 'loggedIn', (newVal, oldVal) ->
    if newVal != oldVal && newVal != undefined && newVal
      getOnlinePlayers()
])
