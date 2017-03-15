(function() {
'use strict';

angular.module('scope')
.component('buildList', {
  templateUrl: ['scope.APP_CONFIG', function(APP_CONFIG) { return APP_CONFIG.build_list_html; }],
  bindings: {
    builds: '<'
  }
});

})();
