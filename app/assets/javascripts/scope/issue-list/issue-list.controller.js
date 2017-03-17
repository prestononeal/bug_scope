(function() {
  'use strict';

  angular.module('scope')
  .controller('IssueListController', IssueListController);

  IssueListController.$inject = ['scope.APP_CONFIG'];
  function IssueListController(APP_CONFIG) {
    var $ctrl = this;
    $ctrl.ticketUrl = APP_CONFIG.ticket_base_url;
  }
})();
