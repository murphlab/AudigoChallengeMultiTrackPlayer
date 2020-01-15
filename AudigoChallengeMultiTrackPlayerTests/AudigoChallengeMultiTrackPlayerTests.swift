//
//  AudigoChallengeMultiTrackPlayerTests.swift
//  AudigoChallengeMultiTrackPlayerTests
//
//  Created by Ken Murphy on 1/15/20.
//  Copyright © 2020 Ken Murphy. All rights reserved.
//

import XCTest
@testable import AudigoChallengeMultiTrackPlayer

class AudigoChallengeMultiTrackPlayerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitializeAudioController() {
        let _ = AudioController()
    }
    
    func testLoadAudioProjects() {
        let audioProjects = ProjectManager.loadAudioProjects()
        assert(audioProjects != nil)
        let drumsProject = audioProjects!["drums"]
        assert(drumsProject != nil)
    }
    
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
