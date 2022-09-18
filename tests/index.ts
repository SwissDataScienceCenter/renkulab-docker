const util = require('util');
const assert_ = require('assert');
const exec = util.promisify(require('child_process').exec);
const axios = require('axios').default;
const wrapper = require("axios-cookiejar-support").wrapper
const CookieJar = require("tough-cookie").CookieJar
const cypress = require('cypress');

const jar = new CookieJar();
const client = wrapper(axios.create({ jar }));
const imageName = process.env.TEST_IMAGE_NAME
const port = process.env.PORT || 8888
const env_name = process.env.TEST_ENV || "lab"
const url = process.env.URL || `http://127.0.0.1:${port}/${env_name}`
const containerName = "testing-dockerlab-image"
const user = process.env.TEST_USER_NAME || "jovyan"
const timeoutSeconds = process.env.TIMEOUT_SECS as unknown as number || 600;
const testSpec = process.env.TEST_SPEC || "jupyterlab.cy.ts";

function sleep(ms: number) {
  // shamelessly ripped off from https://stackoverflow.com/questions/951021/what-is-the-javascript-version-of-sleep
  return new Promise(resolve => setTimeout(resolve, ms));
}

const checkStatusCode = async function (url: string) {
  var count = 0;
  while (true) {
    console.log("Waiting for container to become ready...")
    try {
      const res = await client.get(url)
      if (res.status < 300) {
        console.log(`Response from starting container succeeded with status code: ${res.status}`)
        return {"status": res.status};
      }
    }
    catch (err) {
      console.log(`Waiting to start for a container failed with error: ${err}.`)
    }
    finally {
      if (count > timeoutSeconds / 10) {
        console.log("Waiting for container to become available timed out.")
        return {"error": "Timed out waiting for container to become ready"}
      }
      await sleep(10000);
      count = count + 1;
    }
  }
}

describe(`Starting container with image ${imageName} and name ${containerName}`, function () {
  this.timeout(0);
  before(async function () {
    await exec(`docker run -d -p ${port}:${port} --name ${containerName} --rm --user ${user} --entrypoint="tini" ${imageName} "-g" "--" jupyter lab --ServerApp.port=${port} --NotebookApp.port=${port} --ServerApp.ip=0.0.0.0 --NotebookApp.ip=0.0.0.0 --ServerApp.token="" --NotebookApp.token="" --ServerApp.password=""  --NotebookApp.password="" --NotebookApp.disable_check_xsrf="true" --ServerApp.disable_check_xsrf="true"`);
    const {error} = await checkStatusCode(url);
    assert_(!error)
  });
  it('Should pass all acceptance tests', async function () {
    const results = await cypress.run({
      env: {
        URL: url
      },
      spec: `cypress/e2e/${testSpec}`,
      configFile: "cypress.config.ts",
      browser: "chrome"
    })
    assert_(!results.totalFailed, `Tests failed with errors on chrome.`)
  });
  after(async function () {
    console.log(`Stopping container with image ${imageName} and name ${containerName}`)
    await exec(`docker container stop -t 2 ${containerName}`);
    console.log(`Container successfully stopped`)
  });
});
