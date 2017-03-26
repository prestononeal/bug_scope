import { Component }    from '@angular/core';

import { ScopeService } from './scope.service';

@Component({
  selector: 'issue-detail',
  templateUrl: './issue-detail.component.html',
  providers: [ScopeService]
})
export class IssueDetailComponent {
  constructor(
    private scopeService: ScopeService
  ) { }
}
