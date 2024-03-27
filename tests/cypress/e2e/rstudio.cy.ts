import {
  rstudioTestFuncs,
  registerCustomCommands,
} from "@renku/notebooks-cypress-tests";

const username = Cypress.env("USERNAME");
const password = Cypress.env("PASSWORD");
const url_or_path = Cypress.env("URL");
const url =
  url_or_path.slice(-1) === "/" ? url_or_path.slice(0, -1) : url_or_path;

console.log({ url });

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
        validate() {
          cy.url().then((url) => {
            if (
              url.includes("realms/Renku/protocol/openid-connect") &&
              username.length > 0 &&
              password.length > 0
            ) {
              return false;
            }
          });
        },
      }
    );
    cy.visit(url);
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
