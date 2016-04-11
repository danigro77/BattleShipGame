'use strict'

angular.module('battleShipGameApp').controller("MainCtrl", ['$scope', '$cookieStore', 'PlayerService', (scope, cookieStore, PlayerService)->
  scope.currentPlayer = cookieStore.get('currentPlayer')

  scope.loggedIn = scope.currentPlayer != undefined

  scope.logOut = ->
    cookieStore.put('currentPlayer', undefined)
    scope.currentPlayer = undefined
    scope.loggedIn = false

  scope.$watch 'currentPlayer', (newVal, oldVal) ->
    if newVal != oldVal && newVal != undefined
      scope.loggedIn = true
])
