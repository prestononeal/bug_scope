(function() {
'use strict';

angular.module('Scope')
.controller('BuildsController', BuildsController);

BuildsController.$inject = ['builds'];
function BuildsController(builds) {
  var buildsCtrl = this;

  buildsCtrl.builds = builds.data;
}

})();
