//
//  NetworkError.swift
//  NetworkLayer
//
//  Created by Саидов Тимур on 18.01.2023.
//

import Foundation

enum ParametersEncodingError: Error, CustomStringConvertible {
    case missingURL
    case missingParameters
    case encodingFailed
    
    var description: String {
        switch self {
        case .missingURL:
            return "URL is nil."
        case .missingParameters:
            return "Missing parameters."
        case .encodingFailed:
            return "Parameter encoding failed."
        }
    }
}
