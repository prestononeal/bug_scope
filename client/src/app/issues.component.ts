import { Component, OnInit, Input } from '@angular/core';
import { Router }                   from '@angular/router';

import { Issue }                    from './issue'
import { ScopeService }             from './scope.service'

@Component({
  selector: 'issues',
  templateUrl: './issues.component.html',
  providers: [ScopeService]
})
export class IssuesComponent implements OnInit{
  public rows: Array<any> = [];
  public columns: Array<any> = [
    { title: 'ID', name: 'id' },
    { title: 'Hit Count', name: 'hit_count' },
    { title: 'Type', name: 'issue_type' },
    { title: 'Signature', name: 'signature' },
    { title: 'Note', name: 'note' },
    { title: 'Ticket', name: 'ticket' },
  ];
  public config: any = {
    className: ['table-striped', 'table-bordered']
  };

  @Input() msg: string;
  @Input() query: string;

  constructor(
    private scopeService: ScopeService,
    private router: Router
  ) { }

  issues: Issue[];

  ngOnInit(): void {
    this.query = this.query || '?include_hit_count'
    this.scopeService.getIssues(this.query).then(issues => {
      this.issues = issues;
      this.rows = issues;
    });
  }

  gotoDetail(data: any): void {
    this.router.navigate(['issues', data.row.id]);
  }
}
