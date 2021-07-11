var assert = require('assert');
const util = require('util');
const exec = util.promisify(require('child_process').exec);
const axios = require('axios').default;

const imageName = process.env.TEST_IMAGE_NAME
const port = 8888
const url = `http://127.0.0.1:${port}/lab`
const containerName = "testing-dockerlab-image"

function sleep(ms) {
  // shamelessly ripped off from https://stackoverflow.com/questions/951021/what-is-the-javascript-version-of-sleep
  return new Promise(resolve => setTimeout(resolve, ms));
}

const checkStatusCode = async function (url) {
  var count = 0;
  const maxCount = 10;
  while (true) {
    try {
      res = await axios.get(url)
      if (res.status < 300 || count > maxCount) {
        return res.status;
      }
      count = count + 1;
      await sleep(1000);
    }
    catch (err) {
      await sleep(1000);
      continue;
    }
  }
}

describe(`Starting container with image ${imageName} and name ${containerName}`, function () {
  this.timeout(0);
  before(async function () {
    await exec(`docker run -d -p ${port}:${port} --name ${containerName} --rm --user jovyan --entrypoint tini ${imageName} -g -- start-notebook.sh --ServerApp.port=${port} --NotebookApp.port=${port} --ServerApp.token="" --ServerApp.password="" --NotebookApp.token="" --NotebookApp.password="" --NotebookApp.disable_check_xsrf="true"`);
    res = await checkStatusCode(url);
    console.log(`Container successfully started`)
  });
  it('Should pass all acceptance tests', async function () {
    const {stdout, stderr, error} = await exec(`npx cypress run`);
    console.log(`\n\n--------------------------------------------Cypress stdout--------------------------------------------\n${stdout}`)
    console.log(`\n\n--------------------------------------------Cypress stderr--------------------------------------------\n${stdout}`)
    console.log(`\n\n--------------------------------------------Cypress error--------------------------------------------\n${error}`)
    console.log(`\n\n-----------------------------------------------------------------------------------------------------\n`)
    assert.ok(!error)
  });
  after(async function () {
    console.log(`Stopping container with image ${imageName} and name ${containerName}`)
    await exec(`docker container stop -t 2 ${containerName}`);
    console.log(`Container successfully stopped`)
  });
});