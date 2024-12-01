//
//  GRError.swift
//  Common
//
//  Created by Nafla Diva Syafia on 30/11/24.
//

import Foundation

public enum GameRushError: Error {
    case connectionFailed
    case decodingError
}

extension GameRushError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .connectionFailed:
                return "Network connection error. Please check your internet connection and try again."
            case .decodingError:
                return "Failed to decode the response. Please check the response structure."
            }
    }
}
