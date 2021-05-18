#!/usr/bin/env groovy

@Library('cloud-jenkins-common-libraries@master')

import groovy.transform.Field

String getTerraformDirectory() {
    return "${WORKSPACE}/terraform"
}

Boolean checkFolderForDiffs(String moduleName, String tag) {
    terraformDirectory = getTerraformDirectory()
    git.checkoutBranch(tag)
    try {
        sh "git diff --quiet --exit-code origin/master..HEAD -- ${terraformDirectory}/${moduleName}"
        return false
    } catch (ignored) {
        return true
    }
}

String getDiffForModule(String moduleName, String tag) {
    terraformDirectory = getTerraformDirectory()
    return sh(
        returnStdout: true,
        script: "git diff --name-status origin/master..HEAD -- ${terraformDirectory}/${moduleName}"
    )
}

properties([
    parameters([
        string(name: 'GIT_BRANCH', defaultValue: 'master', description: ''),
        string(name: ' GIT_URL', defaultValue: 'git@github.com:omegion/terraform-modules.git', description: ''),
        booleanParam(name: "DRY_RUN", defaultValue: false, description: "")
    ])
])

podTemplate(
    containers: [
        containerTemplate(
            name: 'alpine',
            image: "alpine:3.13",
            alwaysPullImage: true,
            ttyEnabled: true,
            command: '/bin/ash',
        ),
    ]
) {
    node(POD_LABEL) {
      stage('Git checkout repos') {
        checkout(scm)
      }

      stage('Check for module changes') {
        changedModules = [:]

        // Iterate modules
        def modules = sh(returnStdout: true, script: 'ls -A1 terraform').trim().split(System.getProperty("line.separator"))
        modules.each { moduleName ->
          latestTag = git.latestTag()
          if (checkFolderForDiffs(moduleName, latestTag)) {
            echo "New changes are detected for ${moduleName}"
            changedModules[moduleName] = getDiffForModule(moduleName, latestTag)
          }
        }

        size = changedModules.size()
        echo "${size} modules are changed."

        if (size > 0) {
            echo "Cutting new version for changed modules"
             changedModules.each { module ->
              echo "Module name: ${module.key}"
              echo "Module changes: ${module.value}"
             }
        }
      }
    }
}
