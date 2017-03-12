(function() {
'use strict'

angular.module('scope')
.config(config);

config.$inject = ['$urlRouterProvider', '$stateProvider', 'scope.APP_CONFIG'];
function config($urlRouterProvider, $stateProvider, APP_CONFIG) {

  // If user goes to a path that doesn't exist, redirect to public root
  $urlRouterProvider.otherwise('/');

  $stateProvider
    .state('home', {
      url: '/',
      templateUrl: APP_CONFIG.main_page_html
    })
    .state('issues', {
      url: '/issues',
      templateUrl: APP_CONFIG.issues_html,
      controller: 'IssuesController',
      controllerAs: 'issuesCtrl',
      resolve: {
        issues: ['ScopeDataService', function(ScopeDataService) {
          return ScopeDataService.getIssues({'include_instances_count': null});
        }]
      }
    })
    .state('builds', {
      url: '/builds',
      templateUrl: APP_CONFIG.builds_html,
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
      templateUrl: APP_CONFIG.build_report_html,
      controller: 'BuildReportController',
      controllerAs: 'buildRepCtrl',
      resolve: {
        issues: ['ScopeDataService', '$stateParams', function(ScopeDataService, $stateParams) {
          return ScopeDataService.getIssues({'build_id': $stateParams.id});
        }]
      }
    })
    .state('issue-report', {
      url: '/issues/{id}',
      templateUrl: APP_CONFIG.issue_report_html,
      controller: 'IssueReportController',
      controllerAs: 'issueReportCtrl',
      resolve: {
        issue: ['ScopeDataService', '$stateParams', function(ScopeDataService, $stateParams) {
          return ScopeDataService.getIssue($stateParams.id, 
            {'include_instances_count': null,
             'expand': 'builds'});
        }],
        similar: ['ScopeDataService', '$stateParams', function(ScopeDataService, $stateParams) {
          return ScopeDataService.getIssue($stateParams.id, ['similar_to']);
        }]
      }
    })
    .state('submit', {
      url: '/submit',
      templateUrl: APP_CONFIG.submit_html,
      controller: 'SubmitController',
      controllerAs: 'submitCtrl'
    });
}
})();
