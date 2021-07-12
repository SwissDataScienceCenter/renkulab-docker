# Acceptance Tests for Renkulab Images

## Requirements
- node

## Run Tests
1. Install node packages: `cd tests && npm install`
2. Build a docker image: `docker build -t py docker/py`
3. Test images: `cd tests && TEST_IMAGE_NAME="py" "TEST_USER_NAME=jovyan" npx mocha test.js`

Mocha is used to launch a test session with Cypress for each image. Mocha
captures and displays the logs from Cypress for each test. The reason for having Mocha
launch the Cypress tests is because the Cypress tests cannot run terminal commands
to launch a Jupyterlab container beacuse they operate only in the browser. However,
running Mocha tests does not have this limitation and the Mocha tests can launch 
containers with Jupyterlab as well as all Cypress tests.