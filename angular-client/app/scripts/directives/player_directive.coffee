angular.module('battleShipGameApp').directive 'player', ->
  restrict: 'A'

  controller: 'PlayerCtrl'
  templateUrl: 'views/player.html'
