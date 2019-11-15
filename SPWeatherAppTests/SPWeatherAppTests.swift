//
//  SPWeatherAppTests.swift
//  SPWeatherAppTests
//
//  Created by Aaron Tang on 9/11/19.
//  Copyright © 2019 Aaron Tang. All rights reserved.
//

import XCTest
@testable import SPWeatherApp


class SPWeatherAppTests: XCTestCase {
    let homeSearchVM = searchViewModel()

    func testUserViewedLocations(){
        try! homeSearchVM.getUserLocations()
        let location : Location = Location()
        
        location.areaName = "New York"
        location.country = "New York"
        location.latitude = "40.7128"
        location.longitude = "74.0060"
        location.region = ""
        location.weatherUrl = ""
        
       //XCTAssertEqual(homeSearchVM.locations[0], location, "the array should be sorted properly")


    }
    
    func testSearchLocation(){
        //call API
        homeSearchVM.searchLocation("New York", { (success, result, error) -> Void in
            if(success) {
                self.homeSearchVM.locations.removeAll()
                if(result.count > 0){
                    self.homeSearchVM.locations = result
                }
                
                XCTAssertNil(result)
                XCTAssert(self.homeSearchVM.locations[0].areaName == "New York")
                XCTAssert(self.homeSearchVM.locations[0].country == "New York")
            }
        })
    }
}
