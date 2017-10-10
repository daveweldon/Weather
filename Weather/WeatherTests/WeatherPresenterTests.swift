//
//  WeatherPresenterTests.swift
//  WeatherTests
//
//  Created by David Weldon on 10/10/2017.
//  Copyright © 2017 nsdave. All rights reserved.
//

import XCTest
@testable import Weather

class WeatherViewMock: WeatherView {
    
    var startLoadingCalled = false
    var finishLoadingCalled = false
    var setForecastCalled = false
    var presentErrorCalled = false
    var asyncResult: Bool? = .none
    var asyncExpectation: XCTestExpectation?
    
    func startLoading() {
        startLoadingCalled = true
    }
    
    func finishLoading() {
        finishLoadingCalled = true
    }
    
    func set(forecast: Forecast?) {
        setForecastCalled = true
        
        guard let expectation = asyncExpectation else {
            XCTFail("WeatherView was not setup correctly. Missing XCTExpectation reference")
            return
        }
        
        asyncResult = (forecast != nil)
        expectation.fulfill()
    }
    
    func present(_ error: Error) {
        presentErrorCalled = true
    }
    
}

class WeatherPresenterTests: XCTestCase {
    
    var weatherViewMock: WeatherViewMock?
    var weatherPresenter: WeatherPresenter?
    
    override func setUp() {
        super.setUp()
        weatherViewMock = WeatherViewMock()
        weatherPresenter = WeatherPresenter(weatherView: weatherViewMock!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSearchlocationId_loadingCalled() {
        let expect = expectation(description: "WeatherViewMock calls the delegate as the result of an async method completion")
        weatherViewMock?.asyncExpectation = expect
        
        weatherPresenter?.search(locationId: 100)
        
        XCTAssertTrue(weatherViewMock?.startLoadingCalled ?? false, "Start loading not called in async request")
        
        waitForExpectations(timeout: 10.0) { [weak self] error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            XCTAssertTrue(strongSelf.weatherViewMock?.finishLoadingCalled ?? false, "Finish loading not called in async request")
        }
    }

    func testSearchlocationId_setForecastCalled() {
        let expect = expectation(description: "WeatherViewMock calls the delegate as the result of an async method completion")
        weatherViewMock?.asyncExpectation = expect
        
        weatherPresenter?.search(locationId: 100)
        
        waitForExpectations(timeout: 10.0) { [weak self] error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            XCTAssertTrue(strongSelf.weatherViewMock?.setForecastCalled ?? false, "Set forecast not called in async request")
        }
    }
    
    func testSearchlocationId_presentErrorCalled() {
        let expect = expectation(description: "WeatherViewMock calls the delegate as the result of an async method completion")
        weatherViewMock?.asyncExpectation = expect
        
        weatherPresenter?.search(locationId: -1)
        
        waitForExpectations(timeout: 10.0) { [weak self] error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            XCTAssertTrue(strongSelf.weatherViewMock?.presentErrorCalled ?? false, "Preent error not called in async request")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
