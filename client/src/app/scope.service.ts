import { Injectable } from '@angular/core';
import { Headers, Http } from '@angular/http';

import 'rxjs/add/operator/toPromise';

import { Issue } from './issue'
import { Build } from './build'


@Injectable()
export class ScopeService {
  constructor(private http: Http) { }

  private scopeDataUrl = 'http://localhost:3000/api';  // URL to web api

  getIssues(query=''): Promise<Issue[]> {
    return this.http.get(`${this.scopeDataUrl}/issues/${query}`)
                    .toPromise()
                    .then(response => response.json() as Issue[])
                    .catch(this.handleError);
  }

  getIssue(id: number, query=''): Promise<Issue> {
    return this.http.get(`${this.scopeDataUrl}/issues/${id}` + query)
                    .toPromise()
                    .then(response => response.json() as Issue)
                    .catch(this.handleError);
  }

  getBuilds(): Promise<Build[]> {
    return this.http.get(`${this.scopeDataUrl}/builds`)
                    .toPromise()
                    .then(response => response.json() as Build[])
                    .catch(this.handleError);
  }

  getBuild(id: number): Promise<Build> {
    return this.http.get(`${this.scopeDataUrl}/builds/${id}`)
                    .toPromise()
                    .then(response => response.json() as Build)
                    .catch(this.handleError);

  }

  private handleError(error: any): Promise<any> {
    return Promise.reject(error.message || error);
  }
}
