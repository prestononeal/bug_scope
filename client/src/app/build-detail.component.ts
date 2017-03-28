import { Component, OnInit }      from '@angular/core';
import { ActivatedRoute, Params } from '@angular/router';

import 'rxjs/add/operator/switchMap';

import { ScopeService }           from './scope.service';
import { Build }                  from './build';

@Component({
  selector: 'build-detail',
  templateUrl: './build-detail.component.html',
  providers: [ScopeService]
})
export class BuildDetailComponent implements OnInit {
  constructor(
    private route: ActivatedRoute,
    private scopeService: ScopeService
  ) { }

  build: Build;
  msg: String;

  ngOnInit(): void {
    this.route.params
              .switchMap((params: Params) => this.scopeService.getBuild(+params['id']))
              .subscribe((build: Build) => {
                this.build = build;
                this.msg = `Issues found in ${this.build.product} / ${this.build.branch} / ${this.build.name}`;
              });
  }
}
