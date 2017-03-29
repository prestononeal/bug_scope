import { Component, OnInit }              from '@angular/core';
import { Router, ActivatedRoute, Params } from '@angular/router';

import 'rxjs/add/operator/switchMap';

import { ScopeService }                   from './scope.service';
import { Issue }                          from './issue';

@Component({
  selector: 'issue-detail',
  templateUrl: './issue-detail.component.html',
  providers: [ ScopeService ]
})
export class IssueDetailComponent implements OnInit{
  constructor(
    private router: Router,
    private route: ActivatedRoute,
    private scopeService: ScopeService
  ) { }

  issue: Issue;
  msg: String;
  notePending: String;
  ticketPending: String;
  mergeToPending: String;

  ngOnInit(): void {
    this.route.params
              .switchMap((params: Params) => this.scopeService.issueGet(+params['id'], '?expand=builds'))
              .subscribe((issue: Issue) => this.updateLocalIssueData(issue))
  }

  updateLocalIssueData(issue: Issue): void {
    this.issue = issue;
    this.notePending = this.issue.note;
    this.ticketPending = this.issue.ticket;
    this.msg = `Info for Issue #${this.issue.id}`
  }

  updateRemoteIssueData(params: Object): void {
    this.scopeService.issueUpdate(this.issue.id, params, '?expand=builds')
                     .then(issue => this.updateLocalIssueData(issue));
  }

  mergeTo(): void {
    this.scopeService.issueMergeTo(this.issue.id, Number(this.mergeToPending))
                     .then(issue => this.router.navigate(['issues', issue.id]));
  }
}
