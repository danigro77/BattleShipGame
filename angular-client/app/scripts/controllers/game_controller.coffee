'use strict'

angular.module('battleShipGameApp').controller("GameCtrl", ['$scope', '$cookieStore', 'GameService', 'FieldService', 'ErrorHelper', (scope, cookieStore, GameService, FieldService, ErrorHelper)->
  scope.helper = ErrorHelper

  scope.whosTurn = (name) ->
    if name == 'me' && scope.gameData.myTurn
      'turn'
    else if name == 'them' && !scope.gameData.myTurn
      'turn'
    else
      'no-turn'

  scope.getOpponentsClasses = (field) ->
    classes = ['field_'+field.id]
    if field.is_uncovered
      classes.push 'hit'
      classes.push if field.is_ship_field then 'ship' else 'water'
    else
      classes.push 'water'
    classes.join(" ")

  scope.getMyClasses = (field) ->
    classes = ['field_'+field.id]
    if field.is_uncovered
      classes.push 'hit'
    classes.push if field.is_ship_field then 'ship' else 'water'
    classes.push field.ship_type if field.ship_type
    classes.join(" ")

  scope.selectField = (field) ->
    scope.gameData.myTurn = false
    FieldService.uncoverField(field.id).then (response) ->
      if response.status == 200
        true
    , (errors) ->
      scope.errorMessage = scope.helper.errorMessage(errors)

  scope.endGame = ->
    GameService.pauseGame(scope.gameData.id).then (response) ->
      if response.status == 204
        cookieStore.remove('currentGame')
        scope.$parent.$parent.gameView = false
    , (errors) ->
      scope.errorMessage = scope.helper.errorMessage(errors)

])
