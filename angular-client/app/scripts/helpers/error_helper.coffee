'use strict'

angular.module('battleShipGameApp').factory "ErrorHelper", ->
  helper = {
    errorMessage: (response) ->
      if helper.hasData(response) && helper.isString(response.data)
        message = ["Something went wrong. Please try again later."]
      else if helper.hasData(response)
        message = helper.formatErrorMessage(response.data)
      else
        message = ["No data is provided. Please fill out the form."]
      message

    , formatErrorMessage: (data) ->
      result = []
      keys = Object.keys(data)
      if helper.typeIsArray(keys)
        for key in keys
          k = key.split('_').join(' ')
          k = k.charAt(0).toUpperCase() + k.slice(1)
          if helper.typeIsArray(data[key])
            for d in data[key]
              result.push k + ' ' + d
          else
            result.push k + ' ' + data[key]
      else
        result.push data
      result

    , hasData: (obj) ->
      obj != undefined && obj != null && Object.keys(obj).length > 0

    , typeIsArray: (value) ->
      value and
        typeof value is 'object' and
        value instanceof Array and
        typeof value.length is 'number' and
        typeof value.splice is 'function' and not ( value.propertyIsEnumerable 'length' )

    , isString: (obj) ->
      typeof obj == 'string'

  }
