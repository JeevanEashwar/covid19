//
//  StateListViewModelTests.swift
//  covid19Tests
//
//  Created by Jeevan on 03/05/21.
//

import XCTest
@testable import covid19

class StateListViewModelTests: XCTestCase {
    var sut: StateListViewModel?
    lazy var reloadUICalled: Bool = false
    lazy var handleAPIErrorCalled: Bool = false
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetCovidDataForSuccess() {
        createSubjectUnderTest(shouldSucceedAPI: true)
        sut?.getCovidData()
        XCTAssertNotNil(sut?.covidDataModel)
        XCTAssertTrue(reloadUICalled)
    }
    
    func testGetCovidDataForFailure() {
        createSubjectUnderTest(shouldSucceedAPI: false)
        sut?.getCovidData()
        XCTAssertNil(sut?.covidDataModel)
        XCTAssertTrue(handleAPIErrorCalled)
    }
    
    func testNumberOfStates() {
        createSubjectUnderTest(shouldSucceedAPI: true)
        sut?.getCovidData()
        let actual = sut?.numberOfStates() ?? 0
        let expected = 38
        XCTAssertEqual(expected, actual)
    }
    
    func testStateObjectAt() {
        createSubjectUnderTest(shouldSucceedAPI: true)
        sut?.getCovidData()
        let actual = sut?.stateObjectAt(index: 5)?.activeCases ?? ""
        let expected = "115128"
        XCTAssertEqual(expected, actual)
        
    }
}

extension StateListViewModelTests {
    func createSubjectUnderTest(shouldSucceedAPI: Bool) {
        let service: CovidAPIService
        if shouldSucceedAPI {
            service = CovidAPIService(rootService: SuccessRootAPIService())
        } else {
            service = CovidAPIService(rootService: FailureRootAPIService())
        }
        let reloadUI: (() -> Void) = {
            self.reloadUICalled = true
        }
        let handleAPIError: ((_ error: ServiceError) -> Void) = { (error) in
            self.handleAPIErrorCalled = true
        }
        sut = StateListViewModel(apiService: service)
        sut?.reloadUI = reloadUI
        sut?.handleAPIError = handleAPIError
    }
}
