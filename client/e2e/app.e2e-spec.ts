import { ScopeClientPage } from './app.po';

describe('scope-client App', () => {
  let page: ScopeClientPage;

  beforeEach(() => {
    page = new ScopeClientPage();
  });

  it('should display message saying app works', () => {
    page.navigateTo();
    expect(page.getParagraphText()).toEqual('app works!');
  });
});
