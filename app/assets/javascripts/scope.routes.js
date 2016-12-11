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
    });
}
})();
