(function() {
'use strict';

angular.module('Scope')
.controller('IssueReportController', IssueReportController);

IssueReportController.$inject = ['issue'];
function IssueReportController(issue) {
  var issueReportCtrl = this;

  issueReportCtrl.issue = issue.data;
}

})();
