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

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        if let project = ProjectManager.loadAudioProjects()?[PROJECT_NAME] {
            
            audioController.setAudioProject(project)
            
            self.title = "Project: \(PROJECT_NAME)"
            
        } else {
            print("ERROR: Could not load project with name: \(PROJECT_NAME)")
        }
    }

    @IBAction func playButtonTapped(_ sender: Any) {
        audioController.play()
    }
    
    @IBAction func stopButtonTapped(_ sender: Any) {
        audioController.stop()
    }
    
    // MARK: - Private

}

// MARK: - Table View Delegate

extension ViewController: UITableViewDelegate {

}

// MARK: - Table View Data Source

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioController.audioProject?.tracks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackCell
        cell.trackNameLabel.text = audioController.audioProject?.tracks[indexPath.row]
        return cell
    }
}

class TrackCell: UITableViewCell {
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
}
