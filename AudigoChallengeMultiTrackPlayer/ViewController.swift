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
        
        audioController.audioProject = ProjectManager.loadAudioProjects()?[PROJECT_NAME]
    }

    // MARK: - Private

}

