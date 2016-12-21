(function() {
'use strict';

angular.module('Scope')
.controller('SubmitController', SubmitController);

SubmitController.$inject = ['ScopeDataService'];
function SubmitController() {
  var submitCtrl = this;

  // Watch the form and set to true if valid
  submitCtrl.valid = false;

  // Create the issue reporting structure to send to the backend
  submitCtrl.report = {};
  submitCtrl.report.buildInfo = {};
  submitCtrl.report.buildInfo.product = '';
  submitCtrl.report.buildInfo.branch = '';
  submitCtrl.report.buildInfo.name = '';
  submitCtrl.report.issues = [];
  
  // Create new issue form data to add to the report
  submitCtrl.newIssue = {};
  submitCtrl.newIssue.type = '';
  submitCtrl.newIssue.signature = '';
  submitCtrl.newIssue.count = 0;

  submitCtrl.validateForm = function() {
    if (submitCtrl.report.issues.length) {
      submitCtrl.valid = true;
    } else {
      submitCtrl.valid = false;
    }
  };

  submitCtrl.addIssue = function() {
    submitCtrl.report.issues.unshift(
      {
        type: submitCtrl.newIssue.type,
        signature: submitCtrl.newIssue.signature,
        count: submitCtrl.newIssue.count
      }
    );

    submitCtrl.validateForm();
  };

  submitCtrl.removeIssue = function(index) {
    submitCtrl.report.issues.splice(index, 1);
    submitCtrl.validateForm();
  };
}

})();
