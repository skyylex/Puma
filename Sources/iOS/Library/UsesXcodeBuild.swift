//
//  XcodeBuildAware.swift
//  PumaiOS
//
//  Created by khoa on 30/11/2019.
//

import Foundation
import PumaCore

/// Any task that uses xcodebuild
public protocol UsesXcodeBuild: UsesCommandLine {}

public extension UsesXcodeBuild {
    var program: String { "xcodebuild" }

    func `default`(project: String, scheme: String) {
        self.project(project)
        self.scheme(scheme)
        self.configuration(Configuration.debug)
        self.sdk(Sdk.iPhoneSimulator)
        self.usesModernBuildSystem(enabled: true)
    }

    func project(_ name: String) {
        let normalizedName = name
            .addingFileExtension("xcodeproj")
            .surroundingWithQuotes()
        arguments.insert("-project \(normalizedName)")
    }

    func workspace(_ name: String) {
        let normalizedName = name
            .addingFileExtension("xcworkspace")
            .surroundingWithQuotes()

        arguments.insert("-workspace \(normalizedName)")
    }

    func scheme(_ name: String) {
        let normalizedName = name
            .surroundingWithQuotes()
        arguments.insert("-scheme \(normalizedName)")
    }

    func configuration(_ configuration: String) {
        arguments.insert("-configuration \(configuration)")
    }

    func sdk(_ sdk: String) {
        arguments.insert("-sdk \(sdk)")
    }

    func usesModernBuildSystem(enabled: Bool) {
        arguments.insert("-UseModernBuildSystem=\(enabled ? "YES": "NO")")
    }
}