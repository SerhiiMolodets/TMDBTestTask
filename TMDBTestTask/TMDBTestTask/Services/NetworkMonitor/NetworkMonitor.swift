//
//  NetworkMonitor.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 02.11.2024.
//

import Foundation
import Network
import Combine

extension NWInterface.InterfaceType: @retroactive CaseIterable {
    public static var allCases: [NWInterface.InterfaceType] = [
        .other,
        .wifi,
        .cellular,
        .loopback,
        .wiredEthernet
    ]
}

final class NetworkMonitor {

    private let queue = DispatchQueue(label: "NetworkConnectivityMonitor")
    private let monitor: NWPathMonitor

    @Published private(set) var isConnected: Bool = false
    @Published private(set) var isExpensive: Bool = false
    @Published private(set) var currentConnectionType: NWInterface.InterfaceType?

    private var cancellables = Set<AnyCancellable>()

    init() {
        monitor = NWPathMonitor()
        startMonitoring()
    }

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.isConnected = path.status != .unsatisfied
            self.isExpensive = path.isExpensive
            self.currentConnectionType = NWInterface.InterfaceType.allCases.first(where: { path.usesInterfaceType($0) })
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
