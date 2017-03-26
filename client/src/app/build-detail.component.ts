import { Component }    from '@angular/core';

import { ScopeService } from './scope.service';

@Component({
  selector: 'build-detail',
  templateUrl: './build-detail.component.html',
  providers: [ScopeService]
})
export class BuildDetailComponent {
  constructor(
    private scopeService: ScopeService
  ) { }
}
