'use strict'

angular.module('battleShipGameApp').controller("GameCtrl", ['$scope', '$cookieStore', (scope, cookieStore)->

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
    else
      classes.push if field.is_ship_field then 'ship' else 'water'
    classes.join(" ")

  scope.selectField = (field) ->
    $('.field_'+field.id).addClass('hit')
    if field.is_ship_field
      $('.field_'+field.id).addClass('ship')
#      TODO: send data with player change
#      TODO: receive data about ship or not ship
#      TODO: set player change right away to stop multiple selects
#      TODO: start new data check
    true

  scope.endGame = ->
    cookieStore.remove('currentGame')
    scope.$parent.$parent.gameView = false

])
