//
//  DataRequestTests.swift
//  DataRequestTests
//
//  Created by David Weldon on 08/10/2017.
//  Copyright © 2017 nsdave. All rights reserved.
//

import XCTest
@testable import Weather

class DataRequestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRequestTypeForecast_valid() {
        let query = URLQueryItem(name: "testKey", value: "testValue")
        let url = RequestType.forecast.url(with: [query])
        XCTAssertTrue(url?.absoluteString == "http://api.openweathermap.org/data/2.5/forecast?testKey=testValue&APPID=816287136a0140daed993a38804be8a2&units=metric", "Incorrect creation of forecast url from RequestType")
    }
    
    func testRequst_valid() {
        let expectation = XCTestExpectation(description: "Download weather data")
        
        DataRequest.forecast(with: 2643743) { forecast, error in
            XCTAssertNotNil(forecast, "No data was downloaded.")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequest_invalid() {
        let expectation = XCTestExpectation(description: "Download weather data with invalid id")
        
        DataRequest.forecast(with: 0) { forecast, error in
            XCTAssertNotNil(error, "Data returned incorrectly")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
