import { Component, OnInit }  from '@angular/core';
import { Router }             from '@angular/router';

import { Build }        from './build'
import { ScopeService } from './scope.service'

@Component({
  selector: 'builds',
  templateUrl: './builds.component.html',
  providers: [ScopeService]
})
export class BuildsComponent implements OnInit{
  constructor(
    private scopeService: ScopeService,
    private router: Router
  ) { }

  selectedBuild: Build;
  builds: Build[];

  ngOnInit(): void {
    this.getBuilds();
  }

  onSelect(build: Build): void {
    this.selectedBuild = build;
  }

  getBuilds(): void {
    this.scopeService.getBuilds().then(builds => this.builds = builds);
  }

  gotoDetail(): void {
    // Nothing yet...
  }
}
