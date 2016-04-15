'use strict'

angular.module('battleShipGameApp').controller("StatsCtrl", ['$scope', '$cookieStore', 'PlayerService', 'ErrorHelper', (scope, cookieStore, PlayerService, ErrorHelper)->

  scope.helper = ErrorHelper

  scope.header = if scope.currentPlayer.name == scope.statsData.winner then 'Congrats, ' + scope.statsData.winner else 'Sorry, '+ scope.statsData.winner + ' won'

  scope.exitGame = ->
    PlayerService.exitGame(scope.currentPlayer.id).then (response) ->
      if response.status == 204
        cookieStore.remove('currentGame')
        scope.$parent.statsView = false
        scope.$parent.backToPlayerView = true
        scope.$parent.$parent.backToPlayerView = true
    , (errors) ->
      scope.errorMessage = scope.helper.errorMessage(errors)
])
