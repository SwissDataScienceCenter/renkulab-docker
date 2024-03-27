import {
  rstudioTestFuncs,
  registerCustomCommands,validateLogin
} from "@renku/notebooks-cypress-tests";

const username = Cypress.env("USERNAME");
const password = Cypress.env("PASSWORD");
const url_or_path = Cypress.env("URL");
const url =
  url_or_path.slice(-1) === "/" ? url_or_path.slice(0, -1) : url_or_path;

describe("Basic Rstudio functionality", () => {
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
    cy.visit(url);cy.wait(100)
  });
  it("Successfully loads", rstudioTestFuncs.findExpectedElements);
  it("Can launch a terminal", rstudioTestFuncs.launchTerminal);
  it(
    "Can run terminal command to create a file",
    rstudioTestFuncs.makeFileWithTerminal("new-file.txt")
  );
  it(
    "Can remove the file",
    rstudioTestFuncs.removeFileWithTerminal("new-file.txt")
  );
  it("Can close the terminal", rstudioTestFuncs.closeTerminal);
  it(
    "Can find expected start page elements again",
    rstudioTestFuncs.findExpectedElements
  );
});
