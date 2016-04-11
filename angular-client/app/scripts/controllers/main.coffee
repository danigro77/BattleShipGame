'use strict'

angular.module('battleShipGameApp').controller("MainCtrl", ['$scope', '$cookieStore', 'PlayerService', (scope, cookieStore, PlayerService)->
  scope.currentPlayer = cookieStore.get('currentPlayer')
  scope.showLogin = false
  scope.showSignup = false
  scope.player = {}

  scope.loggedIn = scope.currentPlayer != undefined

  scope.userLogin = ->
    scope.showLogin = true

  scope.userCreate = ->
    scope.showSignup = true

  generateErrorMessage = (message) ->
    msgs = []
    if message["players"]
      msgs.push message["players"].join("\n")

    if message["name"]
      msgs.push "Name " + message["name"].join(".\nName ")

    if message["password"]
      msgs.push "Password " + message["password"].join(".\nPassword ")

    msgs.join(".\n") + '.'

  scope.signIn = (player) ->
    PlayerService.getCurrentPlayer(player).then (response) ->
      if response.status == 200
        player = response.data['player']
        scope.showLogin = false
        scope.loggedIn = true
        scope.currentPlayer = player
        cookieStore.put('currentPlayer', player)
    , (errors) ->
      scope.errorMessage = generateErrorMessage(errors.data)

  scope.signUp = (player) ->
    PlayerService.saveNewPlayer(player).then (response) ->
      if response.status == 200
        player = response.data['player']
        scope.showSignup = false
        scope.loggedIn = true
        scope.currentPlayer = player
        cookieStore.put('currentPlayer', player)
    , (errors) ->
      scope.errorMessage = generateErrorMessage(errors.data)

  scope.logOut = ->
    cookieStore.put('currentPlayer', undefined)
    scope.currentPlayer = undefined
    scope.loggedIn = false

  scope.goBack = (currentView) ->
    switch currentView
      when 'showSignup'
        scope.showSignup = false
      when 'showLogin'
        scope.showLogin = false

  scope.$watch 'showLogin', (newVal, oldVal) ->
    if newVal != oldVal && newVal == false
      scope.errorMessage = undefined

  scope.$watch 'showSignup', (newVal, oldVal) ->
    if newVal != oldVal && newVal == false
      scope.errorMessage = undefined
])
