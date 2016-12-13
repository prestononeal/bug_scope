(function() {
'use strict';

angular.module('Scope')
.component('mergeIssueFlow', {
  templateUrl: 'merge-issue-flow/_merge-issue-flow.html',
  controller: 'MergeIssueFlowController',
  bindings: {
    parentId: '<',
    childId: '<'
  }
});

})();
