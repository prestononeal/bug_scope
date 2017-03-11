(function() {
'use strict';

angular.module('scope')
.controller('IssuesController', IssuesController);

IssuesController.$inject = ['issues'];
function IssuesController(issues) {
  var issuesCtrl = this;
  issuesCtrl.issues = issues.data;
}

})();
