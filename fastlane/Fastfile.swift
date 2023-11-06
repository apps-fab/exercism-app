// This file contains the fastlane.tools configuration
// You can find the documentation at https://docs.fastlane.tools
//
// For a list of all available actions, check out
//
//     https://docs.fastlane.tools/actions
//

import Foundation

class Fastfile: LaneFile {
    func betaLane() {
    desc("Push a new beta build to TestFlight")
        let latestBuild = latestTestflightBuildNumber(appIdentifier: "com.apps-fab.exercism.Exercism")
        incrementBuildNumber(buildNumber: "\(latestBuild + 1)")
        xcversion(version: "15.0")
        buildApp(scheme: "Exercism")
        uploadToTestflight(username: "mugoangela@gmail.com")
        notarize(package: "Exercism.xcodeproj")
    }
}
