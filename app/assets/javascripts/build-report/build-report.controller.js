(function() {
'use strict';

angular.module('Scope')
.controller('BuildReportController', BuildReportController);

BuildReportController.$inject = ['issues']
function BuildReportController(issues) {
  var buildRepCtrl = this;
  buildRepCtrl.issues = issues.data;

  // Populate the chart data
  buildRepCtrl.chart = {};
  buildRepCtrl.chart.options = {legend: {display: true}};
  buildRepCtrl.chart.labels = [];
  buildRepCtrl.chart.data = [];
  for(var i = 0; i < buildRepCtrl.issues.length; i++) {
    buildRepCtrl.chart.labels.push(buildRepCtrl.issues[i].signature);
    buildRepCtrl.chart.data.push(Number(buildRepCtrl.issues[i].instances_count));
  }
}

})();
