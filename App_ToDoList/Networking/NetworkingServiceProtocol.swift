//
//  NetworkingServiceProtocol.swift
//  App_ToDoList
//
//  Created by Владислав on 13.07.2024.
//

import Foundation

protocol NetworkingServiceProtocol {
    func getList(completion: @escaping (Result<ToDoListResponse, NetworkError>) -> Void)
    func updateList(list: [ToDoItem], revision: Int, completion: @escaping (Result<ToDoListResponse, NetworkError>) -> Void)
    func getItem(id: String, completion: @escaping (Result<ToDoResponse, NetworkError>) -> Void)
    func addItem(item: ToDoItem)
    func updateItem(id: String, item: ToDoItem, completion: @escaping (Result<ToDoResponse, NetworkError>) -> Void)
    func deleteItem(id: String, completion: @escaping (Result<ToDoResponse, NetworkError>) -> Void)
}
