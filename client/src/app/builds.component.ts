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
  public rows:Array<any> = [];
  public columns:Array<any> = [
    { title: 'ID', name: 'id' },
    { title: 'Branch', name: 'branch' },
    { title: 'Product', name: 'product' },
    { title: 'Name', name: 'name' },
  ];
  public config: any = {
    className: ['table-striped', 'table-bordered']
  };
  constructor(
    private scopeService: ScopeService,
    private router: Router
  ) { }

  builds: Build[];

  ngOnInit(): void {
    this.getBuilds();
  }

  getBuilds(): void {
    this.scopeService.getBuilds().then(builds => {
      this.builds = builds
      this.rows = builds
    });
  }

  gotoDetail(data: any): void {
    this.router.navigate(['/builds/' + data.row.id]);
  }
}
