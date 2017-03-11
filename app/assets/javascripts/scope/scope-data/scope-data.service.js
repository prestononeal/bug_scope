(function() {
/* 
Service responsible for retrieving data from Scope's backend
*/
'use strict';

angular.module('scope')
.service('ScopeDataService', ScopeDataService);

ScopeDataService.$inject = ['$http'];
function ScopeDataService($http) {
  var service = this;

  service.mergeTo = function(child, parent) {
    // Merge the child issue to the parent
    return $http.put('api/issues/' + child + '/merge_to', {parent_id: parent});
  }

  service.getIssues = function(options) {
    // Pass in an options hash where the key/values 
    // correspond to the filtering parameters in the 
    // GET REST handler.
    var getString = '/api/issues';
    if(options !== undefined) {
      getString += '?';
      var addAmpersand = false;
      for(var key in options) {
        if(addAmpersand) {
          getString += '&';
        }
        getString += key
        if (options[key]) {
          getString+= '=' + options[key];
        }
        addAmpersand = true;
      }
    }
    return $http.get(getString);
  };

  service.getIssue = function(issueId, options) {
    // Pass in an options array where the values
    // correspond to the nested routes in the 
    // GET REST handler.
    options = options || '/'
    return $http.get('/api/issues/' + issueId + options);
  }

  service.getBuilds = function() {
    return $http.get('/api/builds');
  };

  service.updateIssue = function(issueId, params) {
    return $http.put('/api/issues/' + issueId, params)
  };
}

})();
