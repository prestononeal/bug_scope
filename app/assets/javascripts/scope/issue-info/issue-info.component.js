(function() {
'use strict'

angular.module('scope')
.component('issueInfo', {
  templateUrl: ['scope.APP_CONFIG', function(APP_CONFIG) { return APP_CONFIG.issue_info_html; }],
  controller: 'IssueInfoController',
  bindings: {
    issue: '<'
  }
});

})();
