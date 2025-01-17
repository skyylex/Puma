//
//  UpdateSimulator.swift
//  PumaiOS
//
//  Created by khoa on 28/12/2019.
//

import Foundation
import PumaCore

public class UpdateSimulator {
    public var name: String = "Update simulator"
    public var isEnabled = true
    public var simclt = Simclt()

    private var destination: Destination?

    public init(_ closure: (UpdateSimulator) -> Void = { _ in }) {
        closure(self)
    }
}

extension UpdateSimulator: Task {
    public func run(workflow: Workflow, completion: TaskCompletion) {
        handleTryCatch(completion) {
            let getDestinations = GetDestinations()
            if let destination = self.destination,
                let udid = try getDestinations.findUdid(workflow: workflow, destination: destination) {
                simclt.arguments.insert(udid, at: 1)
            } else {
                throw PumaError.invalid
            }

            try simclt.run(workflow: workflow)
        }
    }
}

public extension UpdateSimulator {
    enum DateNetwork: String {
        case wifi
        case _3g = "3g"
        case _4g = "4g"
        case lte
        case lteA = "lte-a"
        case ltePlus = "lte+"
    }

    enum WifiMode: String {
        case searching, failed, active
    }

    enum CellularMode: String {
        case notSupported, searching, failed, active
    }

    enum BatteryState: String {
        case charging, charged, discharging
    }

    func updateStatusBar(
        destination: Destination,
        time: String = "9:41",
        dataNetwork: DateNetwork = .wifi,
        wifiMode: WifiMode = .active,
        wifiBars: String = "3",
        cellularMode: CellularMode = .active,
        cellularBars: String = "4",
        batteryState: BatteryState = .charged,
        batteryLevel: String = "100"
    ) {
        simclt.arguments.append(contentsOf: [
            "status_bar",
            "override",
            "--time", time,
            "--dataNetwork", dataNetwork.rawValue,
            "--wifiMode", wifiMode.rawValue,
            "--wifiBars", wifiBars,
            "--cellularMode", cellularMode.rawValue,
            "--cellularBars", cellularBars,
            "--batteryState", batteryState.rawValue,
            "--batteryLevel", batteryLevel
        ])
    }
}
