'use strict'

angular.module('battleShipGameApp').controller("PlayerCtrl", ['$scope', '$cookieStore', 'PlayerService', 'ErrorHelper', (scope, cookieStore, PlayerService, ErrorHelper)->
  scope.currentPlayer = cookieStore.get('currentPlayer')
  scope.showLogin = false
  scope.showSignup = false
  scope.player = {}
  scope.helper = ErrorHelper

  scope.userLogin = ->
    scope.showLogin = true

  scope.userCreate = ->
    scope.showSignup = true

  scope.signIn = (player) ->
    PlayerService.getCurrentPlayer(player).then (response) ->
      if response.status == 200
        player = response.data['player']
        scope.showLogin = false
        scope.loggedIn = true
        scope.currentPlayer = player
        cookieStore.put('currentPlayer', player)
    , (errors) ->
      scope.$parent.errorMessage = scope.helper.errorMessage(errors)

  scope.signUp = (player) ->
    PlayerService.saveNewPlayer(player).then (response) ->
      if response.status == 200
        player = response.data['player']
        scope.showSignup = false
        scope.loggedIn = true
        scope.currentPlayer = player
        cookieStore.put('currentPlayer', player)
    , (errors) ->
      scope.$parent.errorMessage = scope.helper.errorMessage(errors)

  scope.goBack = (currentView) ->
    switch currentView
      when 'showSignup'
        scope.showSignup = false
      when 'showLogin'
        scope.showLogin = false

  scope.$watch 'showLogin', (newVal, oldVal) ->
    if newVal != oldVal && newVal == false
      scope.$parent.errorMessage = undefined

  scope.$watch 'showSignup', (newVal, oldVal) ->
    if newVal != oldVal && newVal == false
      scope.$parent.errorMessage = undefined

  scope.$watch 'currentPlayer', (newVal, oldVal) ->
    if newVal != oldVal && newVal != undefined
      scope.$parent.currentPlayer = scope.currentPlayer
])
