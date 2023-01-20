//
//  ParameterEncoding.swift
//  NetworkLayer
//
//  Created by Саидов Тимур on 18.01.2023.
//

import Foundation

/// Параметры запроса.
typealias Parameters = [String: Any]

protocol ParameterEncoder {
    /// Кодирование параметров для заданного ресурса.
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}
