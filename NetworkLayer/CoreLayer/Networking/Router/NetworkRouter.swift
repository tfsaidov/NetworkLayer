//
//  NetworkRouter.swift
//  NetworkLayer
//
//  Created by Саидов Тимур on 18.01.2023.
//

import Foundation

typealias NetworkRouterCompletion = (Result<Data, NetworkRouterError>) -> Void

enum NetworkRouterError: Error {
    
    enum RequestError {
        case invalidRequest
        case encodingError
        case other(description: String)
    }
    
    enum ServerError {
        case decodingError
        case noInternetConnection
        case timeout
        case internalServerError
        case other(description: String)
    }
    
    case requestError(RequestError)
    case serverError(ServerError)
}

protocol NetworkRouter: AnyObject {
    /// Отправка запроса.
    func request(_ endPoint: EndPointType, completion: @escaping NetworkRouterCompletion)
    /// Прерывание запроса.
    func cancel()
}

class Router: NetworkRouter {
    
    private var task: URLSessionTask?
    
    func request(_ endPoint: EndPointType, completion: @escaping NetworkRouterCompletion) {
        do {
            let request = try self.buildRequest(from: endPoint)
            self.task = URLSession.shared.dataTask(with: request, completionHandler: { data, responce, error in
                if let error = error {
                    completion(.failure(.serverError(.other(description: error.localizedDescription))))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.serverError(.internalServerError)))
                    return
                }
                
                completion(.success(data))
            })
        } catch {
            completion(.failure(.requestError(.other(description: error.localizedDescription))))
        }
        
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    /// Конфигурация ресурса на основе переданного эндпоинта.
    /// Конвертация EndPointType в URLRequest.
    private func buildRequest(from endPoint: EndPointType) throws -> URLRequest {
        var request = URLRequest(url: endPoint.baseURL.appendingPathComponent(endPoint.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 60)
        request.httpMethod = endPoint.httpMethod.rawValue
        
        do {
            switch endPoint.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case let .requestParameters(bodyParameters, urlParameters):
                try self.configureParameters(bodyParameters: bodyParameters,
                                             urlParameters: urlParameters,
                                             for: &request)
            case let .requestParaemetersAndHeaders(bodyParameters, urlParameters, additionHeaders):
                self.addAdditionalHeaders(additionHeaders, for: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             urlParameters: urlParameters,
                                             for: &request)
            }
            
            return request
        } catch {
            throw error
        }
    }
    
    /// Преобразование параметров запроса.
    private func configureParameters(bodyParameters: Parameters?,
                                     urlParameters: Parameters?,
                                     for request: inout URLRequest) throws {
        do {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
    }
    
    /// Установка заголовков в запрос.
    private func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?,
                                      for request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
