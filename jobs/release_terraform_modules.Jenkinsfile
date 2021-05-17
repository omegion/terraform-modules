#!/usr/bin/env groovy

@Library('cloud-jenkins-common-libraries@master')

import groovy.transform.Field
import org.cloud.MinorVersion
import org.cloud.PatchVersion
import org.cloud.PatchVersionFactory

Boolean checkFolderForDiffs(String path, String tag) {
    git.checkoutBranch(tag)
    try {
        sh "git diff origin/master..HEAD -- ${WORKSPACE}/terraform/${path}"
        return false
    } catch (ignored) {
        return true
    }
}

String getLatestModuleTag(String moduleName) {
    return sh(
        returnStdout: true,
        script: "git tag | egrep \"${moduleName}-[^.]+\\.[^.]+\\.[^.]+\" | sort -V | tail -1"
    )
}

def removeVersionPostfix(String moduleName, String tag) {
  return pVersion.replaceAll("${moduleName}-v", "")
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

      stage('Loop Modules') {
        // Iterate modules
        def modules = sh(returnStdout: true, script: 'ls -A1 terraform').trim().split(System.getProperty("line.separator"))
        modules.each { moduleName ->
          echo "moduleName: ${moduleName}"

          latestTag = getLatestModuleTag(moduleName)

          echo "latestTag: ${latestTag}"

          if (latestTag == "") {
            // create new tag with
            tag = "${moduleName}-v0.1.0"

            echo "Creating new tag for ${moduleName}"

            // create new tag from MASTER.
          } else {
            // checkout to latest module tag
//             git.checkoutBranch(latestTag)
            if (checkFolderForDiffs(moduleName, latestTag)) {
              git.checkoutBranch("master")
              currentVersion = removeVersionPostfix(moduleName, latestTag)

              minorVersion = version.minor(currentVersion, "${moduleName}-v").nextMinorVersion()

              patchVersion = patchVersionFactory().nextPatchVersionFor(minorVersion)

              minVersion = minorVersion.toString()
              echo "Minor: ${minVersion}"

              pVersion = patchVersion.toString()
              echo "Patch: ${pVersion}"
              // create new tag for next version from MASTER.
            }
          }
          // checkout to the latest module tag, how to get latest module tag?
          // check git diff if is there a change in module directory.
            // if there is a change, cut new tag <MODULE_NAME>-<VERSION>.
          // if there is no tag with a module, create new tag for the module.
        }
      }
    }
}
