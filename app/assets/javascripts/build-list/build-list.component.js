(function() {
'use strict';

angular.module('Scope')
.component('buildList', {
  templateUrl: 'build-list/_build-list.html',
  bindings: {
    builds: '<'
  }
});

})();
