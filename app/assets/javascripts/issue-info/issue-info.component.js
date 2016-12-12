(function() {
'use strict'

angular.module('Scope')
.component('issueInfo', {
  templateUrl: 'issue-info/_issue-info.html',
  bindings: {
    issue: '<'
  }
});

})();
