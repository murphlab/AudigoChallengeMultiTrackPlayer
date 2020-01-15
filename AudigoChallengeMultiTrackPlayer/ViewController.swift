//
//  ViewController.swift
//  AudigoChallengeMultiTrackPlayer
//
//  Created by Ken Murphy on 1/15/20.
//  Copyright © 2020 Ken Murphy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let PROJECT_NAME = "drums"
    
    let audioController = AudioController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let project = ProjectManager.loadAudioProjects()?[PROJECT_NAME] {
            audioController.setAudioProject(project)
        } else {
            print("ERROR: Could not load project with name: \(PROJECT_NAME)")
        }
    }

    // MARK: - Private

}

