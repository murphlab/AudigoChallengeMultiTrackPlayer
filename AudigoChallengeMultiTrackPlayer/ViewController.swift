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
        let trackController = audioController.trackController(forIndex: indexPath.row)!
        cell.volumeSlider.value = trackController.volume
        cell.delegate = self
        return cell
    }
}

// MARK: - Track Cell Delegate Implementation

extension ViewController: TrackCellDelegate {
    func trackCell(_ trackCell: TrackCell, didTapMuteButton muteButton: UIButton) {
        let idx = tableView.indexPath(for: trackCell)!.row
        let name = audioController.audioProject!.tracks[idx]
        print("MUTE BUTTON TAPPED FOR TRACK INDEX: \(idx) NAME: \(name)")
    }
    
    func trackCell(_ trackCell: TrackCell, didChangeVolumeSlider slider: UISlider) {
        let idx = tableView.indexPath(for: trackCell)!.row
        let name = audioController.audioProject!.tracks[idx]
        print("VOLUME SLIDER FOR TRACK INDEX: \(idx) NAME: \(name)")
        let trackController = audioController.trackController(forIndex: idx)!
        trackController.volume = slider.value
    }
}

// MARK: - Track Cell Class

class TrackCell: UITableViewCell {
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    weak var delegate: TrackCellDelegate?
    
    @IBAction func muteButtonTapped(_ sender: UIButton) {
        delegate?.trackCell(self, didTapMuteButton: sender)
    }
    
    @IBAction func volumeSliderChanged(_ sender: UISlider) {
        delegate?.trackCell(self, didChangeVolumeSlider: sender)
    }
}

// MARK: - Track Cell Delegate Protocol Definition

protocol TrackCellDelegate: class {
    func trackCell(_ trackCell: TrackCell, didTapMuteButton muteButton: UIButton)
    func trackCell(_ trackCell: TrackCell, didChangeVolumeSlider slider: UISlider)
}
