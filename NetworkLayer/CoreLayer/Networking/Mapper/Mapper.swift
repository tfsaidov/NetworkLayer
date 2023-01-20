//
//  Mapper.swift
//  NetworkLayer
//
//  Created by Саидов Тимур on 20.01.2023.
//

import Foundation

typealias MapperCompletion<T: Decodable> = (Result<T, NetworkRouterError>) -> Void

protocol Mapper {
    /// Парсинг бинарных данных в заданный тип.
    func parse<T: Decodable>(_ type: T.Type,
                             from data: Data,
                             completion: @escaping MapperCompletion<T>)
}

final class MapperImp {
    
    private let parsingQueue = DispatchQueue.global(qos: .background)
    private let mainQueue = DispatchQueue.main
}

extension MapperImp: Mapper {
    
    func parse<T: Decodable>(_ type: T.Type,
                                    from data: Data,
                                    completion: @escaping MapperCompletion<T>) {
        self.parsingQueue.async {
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try decoder.decode(type, from: data)
                self.mainQueue.async { completion(.success(decodedData)) }
            } catch let error {
                self.mainQueue.async { completion(.failure(.parser(.parse(reason: error.localizedDescription)))) }
            }
        }
    }
}
