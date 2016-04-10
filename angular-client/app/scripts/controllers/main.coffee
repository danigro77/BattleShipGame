'use strict'

angular.module('battleShipGameApp').controller("MainCtrl", ['$scope', (scope)->
  scope.currentPlayer = undefined
  scope.showLogin = false
  scope.showSignup = false
  scope.player = {}

  scope.loggedIn = scope.currentPlayer != undefined

  scope.userLogin = ->
    scope.showLogin = true

  scope.userCreate = ->
    scope.showSignup = true

  scope.signIn = (player) ->
    console.log player # TODO: Make call here
    scope.showLogin = false

  scope.signUp = (player) ->
    console.log player # TODO: Make call here
    scope.showSignup = false

  scope.goBack = (currentView) ->
    switch currentView
      when 'showSignup'
        scope.showSignup = false
      when 'showLogin'
        scope.showLogin = false
])
