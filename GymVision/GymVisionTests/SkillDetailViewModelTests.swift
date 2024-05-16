//
//  SkillDetailViewModelTests.swift
//  GymVisionTests
//
//  Created by Vanessa Chambers on 5/16/24.
//

import XCTest
@testable import GymVision

final class SkillDetailViewModelTests: XCTestCase {
    let dateFormatter = DateFormatter()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testInitialization() {
        let skill = Skill(id: UUID(uuidString: "FD22645B-A042-486D-9100-E2B0CFBC1013"), name: "Front Tuck", discipline: .WAG, apparatus: .BB, difficultyValue: .D, description: "Salto fwd tucked to cross stand", copNumber: 5.41, groupNumber: 5, createdAt: dateFormatter.date(from: "2024-04-28T20:40:33Z"), updatedAt: dateFormatter.date(from: "2024-04-28T20:40:33Z"))
        
        let skillDetailViewModel = SkillDetailViewModel(skill: skill)
        
        XCTAssertNotNil(skillDetailViewModel, "The skill view model should not be nil.")
    }
    
    func testGetNiceName() {
        // Testing non-nil single WAG example
        let skillA = Skill(id: UUID(uuidString: "BA709F17-3DA5-4ECC-817B-FE01A3ABE010"), name: "Biles", discipline: .WAG, apparatus: .BB, difficultyValue: .H, description: "Double salto bwd tucked with 2/1 twist (720°)", copNumber: 6.805, groupNumber: 6, namedAfterWAG: [Gymnast(lastName: "Biles", firstName: "Simone", federation: "USA")], yearNamed: 2019, createdAt: dateFormatter.date(from: "2024-04-28T20:41:08Z"), updatedAt: dateFormatter.date(from: "2024-04-28T20:41:08Z"))
        let skillDetailViewModelA = SkillDetailViewModel(skill: skillA)
        guard let nameA = skillDetailViewModelA.namedAfterString else {
            XCTFail("'namedAfterString' property is nil, when it should have a value")
            return
        }
        let expectationA = "This skill is named after Simone Biles of USA. It was added to the code of points in 2019."
        XCTAssertEqual(nameA, expectationA, "Skill named after WAG gymnast should match this string")
        
        // Testing nil example
        let skillB = Skill(id: UUID(uuidString: "FD22645B-A042-486D-9100-E2B0CFBC1013"), name: "Front Tuck", discipline: .WAG, apparatus: .BB, difficultyValue: .D, description: "Salto fwd tucked to cross stand", copNumber: 5.41, groupNumber: 5, createdAt: dateFormatter.date(from: "2024-04-28T20:40:33Z"), updatedAt: dateFormatter.date(from: "2024-04-28T20:40:33Z"))
        let skillDetailViewModelB = SkillDetailViewModel(skill: skillB)
        XCTAssertNil(skillDetailViewModelB.namedAfterString, "Skill with no namedAfterWAG or namedAfterWAG data should have a nil namedAfterString")
        
        
        // TODO: Test non-nil mag example
        
        // TODO: Test non-nil multi example (WAG + MAG)      
        
    }
    
    // MARK: Not sure how to test this yet because the test target doesn't have the access credentials for the bucket
//    func testFetchGifFromS3WithConcurrency() {
//        let skill = Skill(id: UUID(uuidString: "BC36BA08-8F93-4173-97A5-FCCDDB942103"), name: "Arabian", discipline: .WAG, apparatus: .BB, difficultyValue: .F, description: "Arabian salto tucked (take-off bwd with ½ twist [180°], salto fwd)", copNumber: 5.611, groupNumber: 5, hasGif: true, className: "Arabian")
//        let viewModel = SkillDetailViewModel(skill: skill)
//        
//        let exp = expectation(description: "Fetching gif from S3")
//        
//        viewModel.fetchGifFromS3(className: skill.className!)
//        let gifData = viewModel.gifData
//        waitForExpectations(timeout: 10.0)
//        XCTAssertNotNil(gifData, "Gif data should be non-nil")
//    }
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
