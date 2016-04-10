'use strict';

@app = angular.module('battleShipGameApp', [
    'ngAnimate',
    'ngAria',
    'ngCookies',
    'ngMessages',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch'
  ])

@app.config(['$routeProvider',  (routeProvider)->
  routeProvider
  .when('/', {
    templateUrl: 'views/main.html'
    controller: 'MainCtrl'
    controllerAs: 'main'
  })
  .otherwise({
    redirectTo: '/'
  })
])

