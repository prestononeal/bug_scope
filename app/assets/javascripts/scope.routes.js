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
        issues: ['ScopeDataService', function(ScopeDataService) {
          return ScopeDataService.getIssues();
        }]
      }
    })
    .state('builds', {
      url: '/builds',
      templateUrl: 'builds/_builds.html',
      controller: 'BuildsController',
      controllerAs: 'buildsCtrl',
      resolve: {
        builds: ['ScopeDataService', function(ScopeDataService) {
          return ScopeDataService.getBuilds();
        }]
      }
    })
    .state('build-report', {
      url: '/builds/{id}',
      templateUrl: 'build-report/_build-report.html',
      controller: 'IssuesController',
      controllerAs: 'issuesCtrl',
      resolve: {
        issues: ['ScopeDataService', '$stateParams', function(ScopeDataService, $stateParams) {
          return ScopeDataService.getIssues({'build_id': $stateParams.id});
        }]
      }
    })
    .state('issue-report', {
      url: '/issues/{id}',
      templateUrl: 'issue-report/_issue-report.html',
      controller: 'IssueReportController',
      controllerAs: 'issueReportCtrl',
      resolve: {
        issue: ['ScopeDataService', '$stateParams', function(ScopeDataService, $stateParams) {
          return ScopeDataService.getIssue($stateParams.id);
        }],
        similar: ['ScopeDataService', '$stateParams', function(ScopeDataService, $stateParams) {
          return ScopeDataService.getIssue($stateParams.id, ['similar_to']);
        }]
      }
    });
}
})();
