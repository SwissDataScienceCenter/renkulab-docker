var assert = require('assert');
const util = require('util');
const exec = util.promisify(require('child_process').exec);
const axios = require('axios').default;

const imageName = process.env.TEST_IMAGE_NAME
const port = process.env.PORT || 8888
const url = process.env.URL || `http://127.0.0.1:${port}/lab`
const containerName = "testing-dockerlab-image"
const user = process.env.TEST_USER_NAME || "jovyan"

function sleep(ms) {
  // shamelessly ripped off from https://stackoverflow.com/questions/951021/what-is-the-javascript-version-of-sleep
  return new Promise(resolve => setTimeout(resolve, ms));
}

const checkStatusCode = async function (url) {
  var count = 0;
  const maxCount = 10;
  while (true) {
    console.log("Waiting for container to become ready...")
    try {
      res = await axios.get(url)
      if (res.status < 300) {
        return {"status": res.status};
      }
    }
    catch (err) {}
    finally {
      if (count > maxCount) {
        return {"error": "Timed out waiting for container to become ready"}
      }
      await sleep(1000);
      count = count + 1;
    }
  }
}

describe(`Starting container with image ${imageName} and name ${containerName}`, function () {
  this.timeout(0);
  before(async function () {
    await exec(`docker run -d -p ${port}:${port} --name ${containerName} --rm --user ${user} --entrypoint tini ${imageName} -g -- start-notebook.sh --ServerApp.port=${port} --NotebookApp.port=${port} --ServerApp.ip=0.0.0.0 --NotebookApp.ip=0.0.0.0 --ServerApp.token="" --NotebookApp.token="" --ServerApp.password=""  --NotebookApp.password="" --NotebookApp.disable_check_xsrf="true" --ServerApp.disable_check_xsrf="true"`);
    const {_, error} = await checkStatusCode(url);
    assert(!error)
  });
  it('Should pass all acceptance tests', async function () {
    const {stdout, stderr, error} = await exec(`npx cypress run --env URL=${url}`);
    console.log(`\n\n--------------------------------------------Cypress stdout--------------------------------------------\n${stdout}`)
    console.log(`\n\n--------------------------------------------Cypress stderr--------------------------------------------\n${stderr}`)
    console.log(`\n\n--------------------------------------------Cypress error--------------------------------------------\n${error}`)
    console.log(`\n\n-----------------------------------------------------------------------------------------------------\n`)
    assert(!error)
  });
  after(async function () {
    console.log(`Stopping container with image ${imageName} and name ${containerName}`)
    await exec(`docker container stop -t 2 ${containerName}`);
    console.log(`Container successfully stopped`)
  });
});
