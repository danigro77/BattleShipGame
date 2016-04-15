angular.module('battleShipGameApp').directive 'stats', ->
  restrict: 'A'
  scope: {
    statsData: '=',
    currentPlayer: '='
  }

  controller: 'StatsCtrl'
  templateUrl: 'views/stats.html'
