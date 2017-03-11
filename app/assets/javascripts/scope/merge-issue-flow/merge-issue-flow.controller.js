(function() {
'use strict';

angular.module('scope')
.controller('MergeIssueFlowController', MergeIssueFlowController);

MergeIssueFlowController.$inject = ['ScopeDataService'];
function MergeIssueFlowController(ScopeDataService) {
  var $ctrl = this;

  $ctrl.state = 0;

  $ctrl.message = '';

  // Allow users to click this component to merge this issue to a parent
  // Ask for confirmation before making the actual REST call.
  $ctrl.forwardState = function() {
    if ($ctrl.state === 0) {
      $ctrl.message = 'Are you sure?';
      $ctrl.state++;
      return;
    }

    if ($ctrl.state === 1) {
      $ctrl.message = 'Merging...';
      $ctrl.state++;
      ScopeDataService.mergeTo($ctrl.childId, $ctrl.parentId)
      .then(function (response) {
        if(response.data.errors) {
          $ctrl.message = 'Merge failed: ' + response.data.errors;
          $ctrl.state = 0;
          return;
        }
        $ctrl.message = 'Merged!';
        $ctrl.state++;
      })
      .catch(function (error) {
        $ctrl.message = 'Merging failed. Click to try again.'
        $ctrl.state = 0;
      });
      return;
    }

    // If the state is 2, the issue is being merged, do nothing
    // If the state is 3, the issue is already merged, do nothing
  }

  $ctrl.generateMergePromptMsg = function() {
    $ctrl.message = 'Merge ' + $ctrl.childId + ' to ' + $ctrl.parentId + '?';
  }

  $ctrl.resetState = function() {
    $ctrl.generateMergePromptMsg();
    $ctrl.state = 0;
  }

  $ctrl.$onInit = function() {
    $ctrl.resetState();
  }

  $ctrl.$onChanges = function(changes) {
    // If the parent ID or child ID changed, update the prompt 
    // if the user hasn't taken action yet
    if((changes.parentId || changes.childId) && $ctrl.state === 0) {
      $ctrl.generateMergePromptMsg();
    }

  }
}

})();
