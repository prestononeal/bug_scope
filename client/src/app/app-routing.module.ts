import { NgModule }             from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { IssuesComponent }      from './issues.component';
import { BuildsComponent }      from './builds.component';

const routes: Routes = [
  { path: '', redirectTo: '/issues', pathMatch: 'full' },
  { path: 'issues', component: IssuesComponent },
  { path: 'builds', component: BuildsComponent }
];

@NgModule({
  imports: [ RouterModule.forRoot(routes) ],
  exports: [ RouterModule ]
})
export class AppRoutingModule {}
