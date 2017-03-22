import { Component, OnInit }  from '@angular/core';
import { Router }             from '@angular/router';

import { Issue }        from './issue'
import { ScopeService } from './scope.service'

@Component({
  selector: 'issues',
  templateUrl: './issues.component.html',
  providers: [ScopeService]
})
export class IssuesComponent implements OnInit{
  constructor(
    private scopeService: ScopeService,
    private router: Router
  ) { }

  selectedIssue: Issue;
  issues: Issue[];

  ngOnInit(): void {
    this.getIssues();
  }

  onSelect(issue: Issue): void {
    this.selectedIssue = issue;
  }

  getIssues(): void {
    this.scopeService.getIssues().then(issues => this.issues = issues);
  }

  gotoDetail(): void {
    // Nothing yet...
  }
}
