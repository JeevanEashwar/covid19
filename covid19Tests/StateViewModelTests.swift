//
//  StateViewModelTests.swift
//  covid19Tests
//
//  Created by Jeevan on 03/05/21.
//

import XCTest
@testable import covid19

class StateViewModelTests: XCTestCase {

    var sut: StateViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let statewise = Statewise(active: "200", confirmed: nil, deaths: "2", deltaconfirmed: nil, deltadeaths: nil, deltarecovered: nil, lastupdatedtime: nil, migratedother: nil, recovered: "120", state: "Telangana", statecode: "TS", statenotes: "")
        sut = StateViewModel(statewise: statewise)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }
    
    func testActiveCases() {
        XCTAssertEqual("200", sut.activeCases)
    }
    
    func testRecoveredCases() {
        XCTAssertEqual("120", sut.recoveredCases)
    }
    
    func testDeaths() {
        XCTAssertEqual("2", sut.deaths)
    }
    
    func testStateName() {
        XCTAssertEqual("Telangana", sut.stateName)
    }
    
    func testStateMapImage() {
        XCTAssertNotNil(sut.stateMapImage)
    }
}
