//
//  JSONParameterEncoder.swift
//  NetworkLayer
//
//  Created by Саидов Тимур on 18.01.2023.
//

import Foundation

struct JSONParameterEncoder: ParameterEncoder {
    
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = data
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw ParametersEncodingError.encodingFailed
        }
    }
}
