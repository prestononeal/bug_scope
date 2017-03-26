import { BrowserModule }            from '@angular/platform-browser';
import { NgModule }                 from '@angular/core';
import { FormsModule }              from '@angular/forms';
import { HttpModule, JsonpModule }  from '@angular/http';
import { NgbModule }                from '@ng-bootstrap/ng-bootstrap';

import { Ng2TableModule }           from 'ng2-table/ng2-table';

import { AppRoutingModule }         from './app-routing.module';
import { AppComponent }             from './app.component';
import { IssuesComponent }          from './issues.component';
import { BuildsComponent }          from './builds.component';
import { IssueDetailComponent }     from './issue-detail.component';

@NgModule({
  declarations: [
    AppComponent,
    IssuesComponent,
    BuildsComponent,
    IssueDetailComponent
  ],
  imports: [
    NgbModule.forRoot(),
    BrowserModule,
    FormsModule,
    HttpModule,
    JsonpModule,
    AppRoutingModule,
    Ng2TableModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
