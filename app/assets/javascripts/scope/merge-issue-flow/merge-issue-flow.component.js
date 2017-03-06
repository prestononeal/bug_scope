(function() {
'use strict';

angular.module('scope')
.component('mergeIssueFlow', {
  templateUrl: ['scope.APP_CONFIG', function(APP_CONFIG) { return APP_CONFIG.merge_issue_flow_html; }],
  controller: 'MergeIssueFlowController',
  bindings: {
    parentId: '<',
    childId: '<'
  }
});

})();
