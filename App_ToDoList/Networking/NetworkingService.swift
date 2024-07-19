//
//  NetworkingService.swift
//  App_ToDoList
//
//  Created by Владислав on 13.07.2024.
//

import Foundation
import UIKit
import CocoaLumberjackSwift

enum NetworkError: Error {
    case badURL
    case requestFailed
    case unknown
}

class NetworkingService: NetworkingServiceProtocol {
    
    private let session = URLSession.shared
    private let baseURL = "https://hive.mrdekk.ru/todo"
    private let token = "Diriel"
    private var currentRevision: Int32 = 0
    private var isDirty = false
    private var retryDelay = 2.0
    private let maxRetryDelay = 120.0
    private let retryFactor = 1.5
    
    
    //    private var activityCount = 0 {
    //        didSet {
    //            DispatchQueue.main.async {
    //                if self.activityCount > 0 {
    //                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    //                } else {
    //                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
    //                }
    //            }
    //        }
    //    }
    
    private func makeRequest<T: Decodable>(urlRequest: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        Task {
            do {
                let (data, response) = try await session.dataTask(for: urlRequest)
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                print("Request failed: \(error.localizedDescription)")
                retryRequest(urlRequest: urlRequest, completion: completion)
            }
        }
    }
    
    private func retryRequest<T: Decodable>(urlRequest: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        if retryDelay <= maxRetryDelay {
            let jitter = Double.random(in: -retryDelay * 0.05...retryDelay * 0.05)
            let delay = retryDelay + jitter
            
            DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                self.makeRequest(urlRequest: urlRequest, completion: completion)
            }
            
            retryDelay *= retryFactor
        } else {
            completion(.failure(.requestFailed))
        }
    }
    
    // Получить список TODO
    func getList(completion: @escaping (Result<ToDoListResponse, NetworkError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/list/") else {
            completion(.failure(.badURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        makeRequest(urlRequest: request) { (result: Result<ToDoListResponse, NetworkError>) in
            switch result {
            case .success(let response):
                self.currentRevision = response.revision
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }
    
    // Обновить список TODO
    func updateList(list: [ToDoItem], revision: Int, completion: @escaping (Result<ToDoListResponse, NetworkError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/list") else {
            completion(.failure(.badURL))
            return
        }
        let listForServer = ConvertToDoListInResponseList(from: list)
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        
        do {
            let body = try JSONEncoder().encode(listForServer)
            request.httpBody = body
        } catch {
            completion(.failure(.unknown))
            return
        }
        
        makeRequest(urlRequest: request, completion: completion)
    }
    
    // Получить элемент списка TODO
    func getItem(id: String, completion: @escaping (Result<ToDoResponse, NetworkError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/list/\(id)") else {
            completion(.failure(.badURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        makeRequest(urlRequest: request, completion: completion)
    }
    
    // Добавить элемент в список TODO
    func addItem(item: ToDoItem) {
        let json: [String : Any] = [
            "element": item.json
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let urlRequest = URL(string: "\(baseURL)/list/")!
        var request = URLRequest(url: urlRequest)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(currentRevision)", forHTTPHeaderField: "X-Last-Known-Revision")

        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                DDLogInfo("Задача добавлена на сервере")
                print(responseJSON)
            } catch let error{
                print(error.localizedDescription)
            }
        }

        task.resume()
    }
    
    // Изменить элемент в списке TODO
    func updateItem(id: String, item: ToDoItem, completion: @escaping (Result<ToDoResponse, NetworkError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/list/\(id)") else {
            completion(.failure(.badURL))
            return
        }
        let itemForServer = ConvertToDoItemInResponse(from: item)
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(currentRevision)", forHTTPHeaderField: "X-Last-Known-Revision")
        
        do {
            let body = try JSONEncoder().encode(itemForServer)
            request.httpBody = body
        } catch {
            completion(.failure(.unknown))
            return
        }
        
        makeRequest(urlRequest: request, completion: completion)
    }
    
    // Удалить элемент из списка TODO
    func deleteItem(id: String, completion: @escaping (Result<ToDoResponse, NetworkError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/list/\(id)") else {
            completion(.failure(.badURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        makeRequest(urlRequest: request, completion: completion)
    }
    
}
