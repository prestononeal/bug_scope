import { Component, OnInit }      from '@angular/core';
import { ActivatedRoute, Params } from '@angular/router';

import 'rxjs/add/operator/switchMap';

import { ScopeService }       from './scope.service';
import { Issue }              from './issue';

@Component({
  selector: 'issue-detail',
  templateUrl: './issue-detail.component.html',
  providers: [ ScopeService ]
})
export class IssueDetailComponent implements OnInit{
  constructor(
    private route: ActivatedRoute,
    private scopeService: ScopeService
  ) { }

  issue: Issue;
  msg: String;

  ngOnInit(): void {
    this.route.params
              .switchMap((params: Params) => this.scopeService.getIssue(+params['id'], '?expand=builds'))
              .subscribe((issue: Issue) => {
                this.issue = issue;
                this.msg = `Info for Issue #${this.issue.id}`
              })
  }
}
