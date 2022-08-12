# Testing and Building From a CI (Continious Integration) Workflow

This folder contains a base docker file which you can use to test and build the ros packges.

## Testing

Example Azure DevOps Pipeline CI

```yaml
- stage: tests
  jobs:
  - job: tests
    displayName: Ros2 and Colcon Tests
    steps:
    - task: Docker@2
      displayName: Login to ACR
      inputs:
        command: login
        containerRegistry: $(containerRegistry)
    - script: |
        python -m pip install flake8
        make lint-all
      displayName: 'Run flake8 lint tests'
    - script: |
        make ci-test-all
      displayName: 'Ros2 and colcon tests'
    - task: PublishTestResults@2
      condition: succeededOrFailed()
      inputs:
        testResultsFiles: '**/test-results/*result*.xml'
        testRunTitle: 'Publish test results for ROS modules'
        failTaskOnFailedTests: true
    - task: PublishCodeCoverageResults@1
      condition: succeededOrFailed()
      inputs:
        codeCoverageTool: Cobertura
        summaryFileLocation: '**/test-results/*coverage*.xml'
        pathToSources: "$(Build.Repository.LocalPath)/packages"
        failIfCoverageEmpty: false
```

## Building

To Run the CI build you can do

```bash
./package/prepare.sh ${nextRelease.version}
```

Once built, the image is tagged and stored in a container repository. You can then use it with any container orchestration engine of your choice.
