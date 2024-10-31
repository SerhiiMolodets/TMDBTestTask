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

extension DependencyValues {
    var apiClient: TMDBNetworkClient {
        get { self[TMDBNetworkClient.self] }
        set { self[TMDBNetworkClient.self] = newValue }
    }
}
