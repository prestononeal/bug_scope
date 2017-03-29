import { Injectable }     from '@angular/core';
import { Headers, Http }  from '@angular/http';

import 'rxjs/add/operator/toPromise';

import { environment }    from 'environments/environment'
import { Issue }          from './issue'
import { Build }          from './build'


@Injectable()
export class ScopeService {
  constructor(private http: Http) { }

  private scopeDataUrl = environment.scopeDataUrl;

  issuesGet(query=''): Promise<Issue[]> {
    return this.http.get(`${this.scopeDataUrl}/issues/${query}`)
                    .toPromise()
                    .then(response => response.json() as Issue[])
                    .catch(this.handleError);
  }

  issueGet(id: number, query=''): Promise<Issue> {
    return this.http.get(`${this.scopeDataUrl}/issues/${id}${query}`)
                    .toPromise()
                    .then(response => response.json() as Issue)
                    .catch(this.handleError);
  }

  buildsGet(): Promise<Build[]> {
    return this.http.get(`${this.scopeDataUrl}/builds`)
                    .toPromise()
                    .then(response => response.json() as Build[])
                    .catch(this.handleError);
  }

  buildGet(id: number): Promise<Build> {
    return this.http.get(`${this.scopeDataUrl}/builds/${id}`)
                    .toPromise()
                    .then(response => response.json() as Build)
                    .catch(this.handleError);

  }

  issueUpdate(id: number, updateParams: Object, query=''): Promise<Issue> {
    return this.http.put(`${this.scopeDataUrl}/issues/${id}${query}`, updateParams)
                    .toPromise()
                    .then(response => response.json() as Issue)
                    .catch(this.handleError);
  }

  issueMergeTo(id: number, parentId: number): Promise<Issue> {
    return this.http.put(`${this.scopeDataUrl}/issues/${id}/merge_to`, {parent_id: parentId})
                    .toPromise()
                    .then(response => response.json() as Issue)
                    .catch(this.handleError);
  }

  private handleError(error: any): Promise<any> {
    return Promise.reject(error.message || error);
  }
}
