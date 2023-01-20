//
//  URLParameterEncoder.swift
//  NetworkLayer
//
//  Created by Саидов Тимур on 18.01.2023.
//

import Foundation

struct URLParameterEncoder: ParameterEncoder {
    
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else { throw ParametersEncodingError.missingURL }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
           !parameters.isEmpty {
            var queryItems = [URLQueryItem]()
            
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key,
                                             value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                queryItems.append(queryItem)
            }
            
            urlComponents.queryItems = queryItems
            urlRequest.url = urlComponents.url
        }
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}
