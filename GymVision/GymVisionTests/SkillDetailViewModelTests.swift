//
//  SkillDetailViewModelTests.swift
//  GymVisionTests
//
//  Created by Vanessa Chambers on 5/15/24.
//

import XCTest
@testable import GymVision

final class SkillDetailViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let skill = Skill(id: UUID(uuidString: "FD22645B-A042-486D-9100-E2B0CFBC1013"), name: "Front Tuck", discipline: .WAG, apparatus: .BB, difficultyValue: .D, description: "Salto fwd tucked to cross stand", copNumber: 5.41, groupNumber: 5, createdAt: dateFormatter.date(from: "2024-04-28T20:40:33Z"), updatedAt: dateFormatter.date(from: "2024-04-28T20:40:33Z"))
        
        let skillDetailViewModel = SkillDetailViewModel(skill: skill)
        
        XCTAssertNotNil(skillDetailViewModel, "The skill view model should not be nil.")
        
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
