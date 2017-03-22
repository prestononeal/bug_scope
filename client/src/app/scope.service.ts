import { Injectable } from '@angular/core';
import { Headers, Http } from '@angular/http';

import 'rxjs/add/operator/toPromise';

import { Issue } from './issue'
import { Build } from './build'


@Injectable()
export class ScopeService {
  constructor(private http: Http) { }

  private issuesUrl = 'http://localhost:3000/api/issues';  // URL to web api

  getIssues(): Promise<Issue[]> {
    return Promise.resolve([{id: 1, signature: "test1"}, {id: 2, signature: "test2"}]);
  }

  getBuilds(): Promise<Build[]> {
    return Promise.resolve([{id: 1, name: "thisbuild1"}, {id: 2, name: "thisbuild2"}]);
  }
}
