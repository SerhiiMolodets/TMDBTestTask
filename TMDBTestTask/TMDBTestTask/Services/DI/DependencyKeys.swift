//
//  DependencyKey.swift
//  TMDBTestTask
//
//  Created by Serhii Molodets on 31.10.2024.
//

import Foundation
import Dependencies

extension TMDBNetworkClient: DependencyKey {
    static var liveValue: TMDBNetworkClient = TMDBNetworkClient()
}

extension NetworkMonitor: DependencyKey {
    static var liveValue: NetworkMonitor = NetworkMonitor()
}

extension DependencyValues {
    var apiClient: TMDBNetworkClient {
        get { self[TMDBNetworkClient.self] }
        set { self[TMDBNetworkClient.self] = newValue }
    }
    
    var networkMonitor: NetworkMonitor {
        get { self[NetworkMonitor.self] }
        set { self[NetworkMonitor.self] = newValue }
    }
}
