describe('Basic functionality', function() {
  before(function() {
    cy.visit("http://127.0.0.1:8888/lab")
  })
  it('Can find launcher icons', function() {
    cy.get('div.jp-LauncherCard', { timeout: 10000 })
  })
  it('Can find main menu at the top', function() {
    cy.get('div#jp-menu-panel', { timeout: 10000 })
  })
  it('Can launch terminal', function() {
    cy.get('div.jp-LauncherCard[title="Start a new terminal session"]', { timeout: 10000 }).click()
  })
})
