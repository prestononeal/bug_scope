(function() {
'use strict';

angular.module('scope')
.controller('IssueInfoController', IssueInfoController);

IssueInfoController.$inject = ['scope.APP_CONFIG', 'ScopeDataService'];
function IssueInfoController(APP_CONFIG, ScopeDataService) {
  var $ctrl = this;
  $ctrl.mergeToId = '';
  $ctrl.ticketUrl = APP_CONFIG.ticket_base_url;

  $ctrl.updateTicket = function() {
    ScopeDataService.updateIssue($ctrl.issue.id, {note: $ctrl.issue.note, ticket: $ctrl.issue.ticket})
    .then(function(success) {
      $ctrl.issue.ticket = success.data.ticket;
      $ctrl.ticketInfo = 'Update successful';
    })
    .catch(function(error) {
      $ctrl.ticketInfo = 'Update failed';
    });
    $ctrl.ticketInfo = 'Updating';
  };
}

})();
