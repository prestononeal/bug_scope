(function() {
/* 
Service responsible for retrieving data from Scope's backend
*/
'use strict';

angular.module('Scope')
.service('ScopeDataService', ScopeDataService);

ScopeDataService.$inject = ['$http'];
function ScopeDataService($http) {
  var service = this;

  service.getIssues = function(options) {
    // Pass in an options hash where the key/values 
    // correspond to the filtering parameters in the 
    // GET REST handler.
    var getString = '/issues';
    if(options !== undefined) {
      getString += '?';
      for(var key in options) {
        getString += key + '=' + options[key];
      }
    }
    return $http.get(getString);
  };

  service.getIssue = function(issueId, options) {
    // Pass in an options array where the values
    // correspond to the nested routes in the 
    // GET REST handler.
    var getString = '/issues/' + issueId + '/';
    if(options !== undefined) {
      for(var index in options) {
        getString += options[index] + '/';
      }
    }
    return $http.get(getString);
  }

  service.getBuilds = function() {
    return $http.get('/builds');
  };
}

})();
