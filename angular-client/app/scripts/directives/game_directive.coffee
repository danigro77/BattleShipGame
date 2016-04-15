angular.module('battleShipGameApp').directive 'game', ->
  restrict: 'A'
  scope: {
    gameData: '='
  }

  controller: 'GameCtrl'
  templateUrl: 'views/game.html'
