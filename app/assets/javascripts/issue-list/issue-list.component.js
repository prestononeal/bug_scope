(function() {
'use strict'

angular.module('Scope')
.component('issueList', {
  templateUrl: 'issue-list/_issue-list.html',
  bindings: {
    issues: '<',
    parentId: '<'
  }
});

})();
