(function() {
'use strict'

angular.module('Scope')
.config(config);

config.$inject = ['$urlRouterProvider', '$stateProvider'];
function config($urlRouterProvider, $stateProvider) {

  // If user goes to a path that doesn't exist, redirect to public root
  $urlRouterProvider.otherwise('/');

  $stateProvider
    .state('home', {
      url: '/',
      templateUrl: 'home/_home.html'
    })
    .state('issues', {
      url: '/issues',
      templateUrl: 'issues/_issues.html',
      controller: 'IssuesController',
      controllerAs: 'issuesCtrl',
      resolve: {
        issues: ['$http', function($http) {
          return $http.get('/issues');
        }]
      }
    })
    .state('builds', {
      url: '/builds',
      templateUrl: 'builds/_builds.html',
      controller: 'BuildsController',
      controllerAs: 'buildsCtrl',
      resolve: {
        builds: ['$http', function($http) {
          return $http.get('/builds');
        }]
      }
    })
    .state('report', {
      url: '/builds/{id}',
      templateUrl: 'build-report/_build-report.html',
      controller: 'IssuesController',
      controllerAs: 'issuesCtrl',
      resolve: {
        issues: ['$http', '$stateParams', function($http, $stateParams) {
          return $http.get('/issues?build_id=' + $stateParams.id)
        }]
      }
    });
}
})();
