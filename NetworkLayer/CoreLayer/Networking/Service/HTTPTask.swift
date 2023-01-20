//
//  HTTPTask.swift
//  NetworkLayer
//
//  Created by Саидов Тимур on 18.01.2023.
//

import Foundation

/// Конфигурация параметров запроса.
enum HTTPTask {
    /// Обычный запрос.
    case request
    /// Запрос с параметрами.
    case requestParameters(bodyParameters: Parameters?, urlParameters: Parameters?)
    /// Запрос с параметрами и заголовками.
    case requestParaemetersAndHeaders(bodyParameters: Parameters?, urlParameters: Parameters?, additionHeaders: HTTPHeaders?)
}
