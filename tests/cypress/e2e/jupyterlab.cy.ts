import {
  jupyterlabTestFuncs,
  registerCustomCommands,
  validateLogin,
} from "@renku/notebooks-cypress-tests";

const username = Cypress.env("USERNAME");
const password = Cypress.env("PASSWORD");
const url_or_path = Cypress.env("URL");
const url =
  url_or_path.slice(-1) === "/" ? url_or_path.slice(0, -1) : url_or_path;

describe("Test jupyter notebook", () => {
  before(() => {
    registerCustomCommands();
  });
  beforeEach(() => {
    cy.session(
      "login-rstudio",
      () => {
        cy.visit(url);
        cy.renkuLoginIfRequired(username, password);
      },
      {
        validate: () => validateLogin(username, password),
      }
    );
    cy.visit(url);
    cy.wait(100);
  });
  it("Successfully loads", jupyterlabTestFuncs.findExpectedElements);
  it("Can launch a terminal", jupyterlabTestFuncs.launchTerminal);
  it(
    "Can run terminal command to create a file",
    jupyterlabTestFuncs.makeFileWithTerminal("new-file.txt")
  );
  it(
    "Can remove the file",
    jupyterlabTestFuncs.removeFileWithTerminal("new-file.txt")
  );
  it("Can close the terminal", jupyterlabTestFuncs.closeTerminal);
  it(
    "Can find expected start page elements again",
    jupyterlabTestFuncs.findExpectedElements
  );
});
