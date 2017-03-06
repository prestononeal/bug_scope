(function() {
'use strict'

angular.module('scope')
.component('issueList', {
  templateUrl: ['scope.APP_CONFIG', function(APP_CONFIG) { return APP_CONFIG.issue_list_html; }],
  bindings: {
    issues: '<',
    parentId: '<'
  }
});

})();
