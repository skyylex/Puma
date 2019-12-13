//
//  CommandLineAware.swift
//  PumaCore
//
//  Created by khoa on 30/11/2019.
//

import Foundation

/// Any task that uses command line
public protocol UsesCommandLine: AnyObject {}

public extension UsesCommandLine {

    @discardableResult
    func runBash(
        workflow: Workflow,
        program: String,
        arguments: [String],
        processHandler: ProcessHandler = DefaultProcessHandler()
    ) throws -> String {
        let joinedArguments = arguments.joined(separator: " ")
        let command = "\(program) \(joinedArguments)"
        Deps.console.highlight(command)

        let process = Process()
        process.launchPath = "/bin/bash"
        process.arguments = ["-c", command]

        return try runProcess(process, workflow: workflow, processHandler: processHandler)
    }

    @discardableResult
    func runProcess(
        _ process: Process,
        workflow: Workflow,
        processHandler: ProcessHandler = DefaultProcessHandler()
    ) throws -> String {
        process.apply(workflow: workflow)
        return try process.run(processHandler: processHandler)
    }
}
