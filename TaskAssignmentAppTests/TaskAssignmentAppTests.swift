//
//  TaskAssignmentAppTests.swift
//  TaskAssignmentAppTests
//
//  Created by Vignesh on 30/09/21.
//

import XCTest
@testable import TaskAssignmentApp

class TaskAssignmentAppTests: XCTestCase {

    var searchView: SearchViewController?
    
    override func setUpWithError() throws {
         searchView = SearchViewController()
    }

    override func tearDownWithError() throws {
        searchView = nil
    }

    func testMinCharterError() {
        XCTAssertThrowsError(try searchView?.errorHandling(text: "rep")) { error in
            XCTAssertEqual(error as? String, MyError.minCharterError(value: minCharterError).associatedValue())
        }
    }
    
    func testMaxCharterError() {
        XCTAssertThrowsError(try searchView?.errorHandling(text: "reprepreprepreprepreprepreprepreprepssssss")) { error in
            XCTAssertEqual(error as? String, MyError.maxCharterError(value: maxCharterError).associatedValue())
        }
    }
    
    func testInvalidError() {
        XCTAssertThrowsError(try searchView?.errorHandling(text: "rep-=")) { error in
            XCTAssertEqual(error as? String, MyError.invalidTextError(value: invalidTextError).associatedValue())
        }
    }
    
    func testValidText() {
        XCTAssertNoThrow(try searchView?.errorHandling(text: "search"))
    }
   
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
        }
    }

}
