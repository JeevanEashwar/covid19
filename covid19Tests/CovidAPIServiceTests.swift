//
//  CovidAPIServiceTests.swift
//  covid19Tests
//
//  Created by Jeevan on 29/04/21.
//

import XCTest
@testable import covid19

class CovidAPIServiceTests: XCTestCase {

    var sut: CovidAPIService!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }
    
    func testGetCovidNumbersForSuccess() {
        sut = CovidAPIService(rootService: SuccessRootAPIService())
        sut.getCovidNumbers { (result) in
            switch result {
            case .success(let data):
                XCTAssertEqual(data.casesTimeSeries.count, 457)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }
}
