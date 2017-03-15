(function() {
'use strict';

angular.module('scope')
.controller('IssueInfoController', IssueInfoController);

IssueInfoController.$inject = ['ScopeDataService'];
function IssueInfoController(ScopeDataService) {
  var $ctrl = this;
  $ctrl.linkToId = '';

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
