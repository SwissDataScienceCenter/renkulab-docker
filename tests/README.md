# Acceptance Tests for Renkulab Images

## Requirements
- node
- docker

## Run Tests
The following instructions assume that the user has navigated to the `test` folder already.

1. Install node packages: `npm install`
2. Build the docker images: 

```
docker build -t py ../docker/py
docker build -t cuda-tf --build-arg BASE_IMAGE=py ../docker/cuda-tf/
docker build -t generic --build-arg RENKU_BASE=py ../docker/generic/
docker build -t julia --build-arg BASE_IMAGE=py ../docker/julia/
docker build -t r --build-arg RENKU_BASE=py ../docker/r/
```

3. Test an image: `TEST_IMAGE_NAME="py" TEST_USER_NAME="jovyan" npx mocha test.js`

Mocha is used to launch a test session with Cypress for each image. Mocha
captures and displays the logs from Cypress for each test. The reason for having Mocha
launch the Cypress tests is because the Cypress tests cannot run terminal commands
to launch a Jupyterlab container beacuse they operate only in the browser. However,
running Mocha tests does not have this limitation and the Mocha tests can launch 
containers with Jupyterlab as well as all Cypress tests.