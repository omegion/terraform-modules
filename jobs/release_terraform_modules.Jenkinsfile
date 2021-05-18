#!/usr/bin/env groovy

@Library('cloud-jenkins-common-libraries@master')

import groovy.transform.Field
import org.cloud.MinorVersion
import org.cloud.PatchVersion
import org.cloud.PatchVersionFactory

Boolean checkFolderForDiffs(String path, String tag) {
    git.checkoutBranch(tag)
    try {
        sh "git diff --quiet --exit-code origin/master..HEAD -- ${WORKSPACE}/terraform/${path}"
        return false
    } catch (ignored) {
        return true
    }
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
        // Iterate modules
        def modules = sh(returnStdout: true, script: 'ls -A1 terraform').trim().split(System.getProperty("line.separator"))
        modules.each { moduleName ->
          latestTag = git.latestTag()
          if (checkFolderForDiffs(moduleName, latestTag)) {
            echo "New changes are detected for ${moduleName}"
          } else {
            echo "No new changes are detected for ${moduleName}"
          }
        }
      }
    }
}
