(function() {
'use strict';

angular.module('Scope')
.controller('IssueInfoController', IssueInfoController);

IssueInfoController.$inject = ['ScopeDataService'];
function IssueInfoController(ScopeDataService) {
  var $ctrl = this;

  $ctrl.updateTicket = function() {
    ScopeDataService.updateIssue($ctrl.issue.id, {ticket: $ctrl.issue.ticket})
    .then(function(success) {
      $ctrl.issue.ticket = success.data.ticket;
      $ctrl.info = 'Update successful';
    })
    .catch(function(error) {
      $ctrl.info = 'Update failed';
    });
    $ctrl.info = 'Updating';
  }
}

})();
