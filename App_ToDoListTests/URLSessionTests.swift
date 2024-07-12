//
//  URLSessionTests.swift
//  App_ToDoListTests
//
//  Created by Владислав on 12.07.2024.
//

import XCTest
@testable import App_ToDoList

final class URLSessionTests: XCTestCase {
    
    func testAsyncDataTask() async throws {
        let session = URLSession.shared
        let url = URL(string: "https://hive.mrdekk.ru/todo/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await session.dataTask(for: request)
            XCTAssertNotNil(data, "Data should not be nil")
            XCTAssertNotNil(response, "Response should not be nil")
            if let httpResponse = response as? HTTPURLResponse {
                XCTAssertEqual(httpResponse.statusCode, 200, "Status code should be 200")
            }
        } catch {
            XCTFail("Request failed with error: \(error)")
        }
    }

    func testAsyncDataTaskCancellation() async throws {
        let session = URLSession.shared
        let url = URL(string: "https://hive.mrdekk.ru/todo/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let expectation = XCTestExpectation(description: "Task should be cancelled")

        // Создание копии запроса вне задачи
        let localRequest = request

        let task = Task {
            do {
                try await Task.sleep(nanoseconds: 5 * 1_000_000_000)
                let _ = try await session.dataTask(for: localRequest)
                XCTFail("Request should have been cancelled")
            } catch {
                if error is CancellationError {
                    expectation.fulfill()
                } else {
                    XCTFail("Request failed with unexpected error: \(error)")
                }
            }
        }

        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            task.cancel()
        }
        await fulfillment(of: [expectation], timeout: 5.0)
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
