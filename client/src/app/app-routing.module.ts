import { NgModule }             from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { IssuesComponent }      from './issues.component';
import { BuildsComponent }      from './builds.component';
import { IssueDetailComponent } from './issue-detail.component'


const routes: Routes = [
  { path: '', redirectTo: '/issues', pathMatch: 'full' },
  { path: 'issues', component: IssuesComponent },
  { path: 'issues/:id', component: IssueDetailComponent },
  { path: 'builds', component: BuildsComponent }
];

@NgModule({
  imports: [ RouterModule.forRoot(routes, { useHash: true }) ],
  exports: [ RouterModule ]
})
export class AppRoutingModule {}
