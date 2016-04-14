'use strict'

angular.module('battleShipGameApp').service "FieldService", [ '$http', (http) ->

  @uncoverField = (id) ->
    http.put '/api/fields/uncover/' + id

  @
]
