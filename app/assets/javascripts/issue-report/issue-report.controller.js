(function() {
'use strict';

angular.module('Scope')
.controller('IssueReportController', IssueReportController);

IssueReportController.$inject = ['issue', 'similar'];
function IssueReportController(issue, similar) {
  var issueReportCtrl = this;

  issueReportCtrl.issue = issue.data;
  issueReportCtrl.similar = similar.data;
}

})();
