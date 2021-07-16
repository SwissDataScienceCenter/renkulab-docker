describe('Basic functionality', function() {
  before(function() {
    cy.visit(Cypress.env("URL"))
  })
  it('Can find launcher icons', function() {
    cy.get('div.jp-LauncherCard')
  })
  it('Can find main menu at the top', function() {
    cy.get('div#jp-menu-panel')
  })
  it('Can launch terminal', function() {
    cy.get('div.jp-LauncherCard[title="Start a new terminal session"]').click()
  })
  it('Runs a command in the terminal to make new file', function () {
    cy.get('canvas.xterm-link-layer')
    cy.get('div.xterm-screen').click().type("touch new-file.txt{enter}")
  })
  it('Can see the new file in the file browser', function () {
    cy.get('button[title="Refresh File List"]').click().wait(2000)
    cy.get('li.jp-DirListing-item[title^="Name: new-file.txt"]')
  })
})
