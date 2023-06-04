//
//  FileServiceTests.swift
//  ChatAppTests
//
//  Created by Эрмек Жоробеков on 11.05.2023.
//

import XCTest
import Combine
@testable import ChatApp

final class FileServiceTests: XCTestCase {

    var fileManager: FileManagerMock!
    var fileService: FileServiceProtocol!
    var userRequest: Cancellable?
    
    override func setUp() {
        fileManager = FileManagerMock()
        fileService = FileService(fileManager: fileManager)
    }
    
    override func tearDown() {
        fileManager = nil
        fileService = nil
        userRequest = nil
    }
    
    func testGetUser() {
        let expected = User(id: "123", name: "New User", bio: "New User Bio")
        fileManager.stubbedGetUserCompletionResult = (Result.success(expected), ())
       
        let expectation = XCTestExpectation(description: "Get User")
        userRequest = fileService.getUser()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Error: \(error)")
                }
            }, receiveValue: { [weak self] user in
                guard let self else { return }
                XCTAssertTrue(self.fileManager.invokedGetUser)
                XCTAssertEqual(self.fileManager.invokedGetUserCount, 1)
                XCTAssertEqual(expected.id, user.id)
                XCTAssertEqual(expected.name, user.name)
                XCTAssertEqual(expected.bio, user.bio)
            })
        let result = XCTWaiter.wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(result, .completed)
    }
    
    func testSaveUser() {
        let expected = User(id: "123", name: "New User", bio: "New User Bio")
        fileManager.stubbedSaveUserCompletionResult = (true, ())
        
        let expectation = XCTestExpectation(description: "Save User")
        userRequest = fileService.saveUser(expected)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Error: \(error)")
                }
            }, receiveValue: { [weak self] isSaved in
                guard let self else { return }
                XCTAssertTrue(self.fileManager.invokedSaveUser)
                XCTAssertEqual(self.fileManager.invokedSaveUserCount, 1)
                XCTAssertEqual(expected.id, self.fileManager.invokedSaveUserParameters?.userPublisher.output.id)
                XCTAssertEqual(expected.name, self.fileManager.invokedSaveUserParameters?.userPublisher.output.name)
                XCTAssertEqual(expected.bio, self.fileManager.invokedSaveUserParameters?.userPublisher.output.bio)
                XCTAssertTrue(isSaved)
            })
        let result = XCTWaiter.wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(result, .completed)
    }
}
