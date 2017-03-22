import { Component }          from '@angular/core';
import { Router }             from '@angular/router';
import { NgbTabChangeEvent }  from '@ng-bootstrap/ng-bootstrap';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent{

  constructor(
    private router: Router
  ) { }

  tabChange(event): void {
    if (event.nextId === 'issues') {
      this.gotoIssues();
    } else if (event.nextId === 'builds') {
      this.gotoBuilds();
    }
  }

  gotoIssues(): void {
    this.router.navigate(['/issues']);
  }

  gotoBuilds(): void {
    this.router.navigate(['/builds'])
  }
}
