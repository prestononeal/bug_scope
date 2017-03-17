(function() {
'use strict';

angular.module('scope')
.controller('IssueReportController', IssueReportController);

IssueReportController.$inject = ['scope.APP_CONFIG', 'issue', 'similar'];
function IssueReportController(APP_CONFIG, issue, similar) {
  var issueReportCtrl = this;

  issueReportCtrl.ticketUrl = APP_CONFIG.ticket_base_url;

  issueReportCtrl.issue = issue.data;
  issueReportCtrl.similar = similar.data;
}

})();
