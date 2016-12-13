(function() {
'use strict';

angular.module('Scope')
.controller('MergeIssueFlowController', MergeIssueFlowController);

MergeIssueFlowController.$inject = ['ScopeDataService'];
function MergeIssueFlowController(ScopeDataService) {
  var $ctrl = this;

  $ctrl.state = 0;

  $ctrl.message = '';

  // Allow users to click this component to link this issue to a parent
  // Ask for confirmation before making the actual REST call.
  $ctrl.forwardState = function() {
    if ($ctrl.state === 0) {
      $ctrl.message = 'Are you sure?';
      $ctrl.state++;
      return;
    }

    if ($ctrl.state === 1) {
      $ctrl.message = 'Linking...';
      $ctrl.state++;
      ScopeDataService.mergeTo($ctrl.childId, $ctrl.parentId)
      .then(function (response) {
        $ctrl.message = 'Linked!';
        $ctrl.state++;
      })
      .catch(function (error) {
        $ctrl.message = 'Linking failed. Click to try again.'
        $ctrl.state = 0;
      });
      return;
    }

    // If the state is 2, the issue is being linked, do nothing
    // If the state is 3, the issue is already linked, do nothing
  }

  $ctrl.resetState = function() {
    $ctrl.message = 'Link ' + $ctrl.childId + ' to ' + $ctrl.parentId + '?';
    $ctrl.state = 0;
  }

  $ctrl.$onInit = function() {
    $ctrl.resetState();
  }
}

})();
