//
//  LocationPresenterTests.swift
//  WeatherTests
//
//  Created by David Weldon on 10/10/2017.
//  Copyright © 2017 nsdave. All rights reserved.
//

import XCTest
@testable import Weather

class LocationViewMock: LocationView {
    
    var setLocationsCalled = false
    var locations: [Location]?
    
    func set(locations: [Location]) {
        setLocationsCalled = true
        self.locations = locations
    }
}

class LocationPresenterTests: XCTestCase {
    
    var locationPresenter: LocationPresenter?
    var locationViewMock: LocationViewMock?
    
    override func setUp() {
        super.setUp()
        locationViewMock = LocationViewMock()
        locationPresenter = LocationPresenter(locationView: locationViewMock!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSetLocations_successful() {
        locationPresenter?.searchTerm("London")
        XCTAssertTrue(locationViewMock?.setLocationsCalled == true, "set locations not called on presenter")
        XCTAssertTrue(locationViewMock?.locations?.count ?? 0 > 0, "An error occurred querying the realm database")
    }
    
    func testSetLocations_caseInsensitive() {
        locationPresenter?.searchTerm("London")
        let resultCount = locationViewMock?.locations?.count ?? 0
        locationPresenter?.searchTerm("LONDON")
        XCTAssertTrue(locationViewMock?.locations?.count ?? 0 == resultCount, "Case insensitive search term not returning equal results")
    }

    func testSetLocations_empty() {
        locationPresenter?.searchTerm("")
        XCTAssertTrue(locationViewMock?.setLocationsCalled == true, "set locations not called on presenter")
        XCTAssertTrue(locationViewMock?.locations?.count == 209579, "An error occurred querying the realm database")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
