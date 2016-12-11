(function() {
'use strict';

angular.module('Scope')
.controller('IssuesController', IssuesController);

IssuesController.$inject = ['issues'];
function IssuesController(issues) {
  var issuesCtrl = this;

  issuesCtrl.issues = issues.data;
}

})();