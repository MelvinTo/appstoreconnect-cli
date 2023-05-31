// Copyright 2020 Itty Bitty Apps Pty Ltd

import ArgumentParser
import AppStoreConnect_Swift_SDK
import Combine
import Foundation

struct ListBuildsCommand: CommonParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "list",
        abstract: "Find and list builds for all apps in App Store Connect.")

    @OptionGroup()
    var common: CommonOptions

    @Option(
        parsing: .upToNextOption,
        help: ArgumentHelp(
            "Filter by app bundle identifier. eg. com.example.App",
            valueName: "bundle-id"
        )
    )
    var filterBundleIds: [String] = []

    @Flag(
        inversion: .prefixedNo,
        exclusivity: .exclusive,
        help: ArgumentHelp(
            "Whether expired builds should be included."
        )
    )
    var includeExpired = true

    @Option(
        parsing: .upToNextOption,
        help: ArgumentHelp(
            "Filter by the pre-release version number of a build",
            valueName: "pre-release-version"
        )
    )
    var filterPreReleaseVersions: [String] = []

    @Option(
        parsing: .upToNextOption,
        help: ArgumentHelp(
            "Filter by the build number of a build",
            valueName: "build-number"
        )
    )
    var filterBuildNumbers: [String] = []

    @Option(
        parsing: .upToNextOption,
        help: ArgumentHelp(
            "Filter by the processing state a build \(ListBuilds.Filter.ProcessingState.allCases)",
            valueName: "processing-state"
        )
    )
    var filterProcessingStates: [ListBuilds.Filter.ProcessingState] = []

    @Option(
        parsing: .upToNextOption,
        help: ArgumentHelp(
            "Filter by the beta review state of a build",
            valueName: "beta-review-state"
        )
    )
    var filterBetaReviewStates: [String] = []

    @Option(
        parsing: .upToNextOption,
        help: ArgumentHelp(
            "Filter by beta groups that this build is associated with",
            valueName: "beta-groups"
        )
    )
    var filterBetaGroups: [String] = []

    @Option(help: "Limit the number of individualTesters & betaBuildLocalizations")
    var limit: Int?

    func run() throws {
        let service = try makeService()

        let builds = try service.listBuilds(
            filterBundleIds: filterBundleIds,
            filterExpired: includeExpired ? [] : ["false"],
            filterPreReleaseVersions: filterPreReleaseVersions,
            filterBuildNumbers: filterBuildNumbers,
            filterProcessingStates: filterProcessingStates,
            filterBetaReviewStates: filterBetaReviewStates,
            filterBetaGroups: filterBetaGroups,
            limit: limit
        )

        builds.render(options: common.outputOptions)
    }
}
