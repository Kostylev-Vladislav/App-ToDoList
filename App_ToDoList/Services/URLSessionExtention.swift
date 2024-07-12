//
//  URLSessionExtention.swift
//  App_ToDoList
//
//  Created by Владислав on 11.07.2024.
//

import Foundation

import Foundation

//extension URLSession {
//    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
//        return try await withCheckedThrowingContinuation { continuation in
//            let task = self.dataTask(with: urlRequest) { data, response, error in
//                if let error = error {
//                    continuation.resume(throwing: error)
//                } else if let data = data, let response = response {
//                    continuation.resume(returning: (data, response))
//                } else {
//                    continuation.resume(throwing: URLError(.badServerResponse))
//                }
//            }
//            task.resume()
//        }
//    }
//}
extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: URLError(.badServerResponse))
                }
            }
            
            // Запуск задачи
            task.resume()
            
            // Обработка отмены задачи
            Task {
                if Task.isCancelled {
                    task.cancel()
                }
            }
        }
    }
}



