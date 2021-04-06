//
//  ViewController.swift
//  AudigoChallengeMultiTrackPlayer
//
//  Created by Ken Murphy on 1/15/20.
//  Copyright © 2020 Ken Murphy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let PROJECT_NAME = "phase2"
    
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
    
    @IBAction func renderButtonTapped(_ sender: Any) {
        audioController.render()
    }
    
    // MARK: - Private

}

// MARK: - Table View Delegate

extension ViewController: UITableViewDelegate {

}

// MARK: - Table View Data Source

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Tracks" : "Effects"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return audioController.audioProject?.tracks.count ?? 0
        } else {
            return audioController.audioProject?.effects.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackCell
            cell.trackNameLabel.text = audioController.audioProject?.tracks[indexPath.row]
            let trackController = audioController.trackController(forIndex: indexPath.row)!
            cell.volumeSlider.value = trackController.volume
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EffectCell", for: indexPath) as! EffectCell
            cell.effectNameLabel.text = audioController.audioProject?.effects[indexPath.row]
            let effectController = audioController.effectController(forIndex: indexPath.row)!
            cell.mixSlider.value = effectController.wetDryMix / 100
            cell.delegate = self
            return cell
        }
    }
}

// MARK: - Track Cell Delegate Implementation

extension ViewController: TrackCellDelegate {
    func trackCell(_ trackCell: TrackCell, didTapMuteButton muteButton: UIButton) {
        let idx = tableView.indexPath(for: trackCell)!.row
        let trackController = audioController.trackController(forIndex: idx)!
        trackController.mute = muteButton.isSelected
    }
    
    func trackCell(_ trackCell: TrackCell, didChangeVolumeSlider slider: UISlider) {
        let idx = tableView.indexPath(for: trackCell)!.row
        let trackController = audioController.trackController(forIndex: idx)!
        trackController.volume = slider.value
    }
}

// MARK: - Effect Cell Delegate Implementation

extension ViewController: EffectCellDelegate {
    func effectCell(_ effectCell: EffectCell, didChangeMixSlider slider: UISlider) {
        let idx = tableView.indexPath(for: effectCell)!.row
        let effectController = audioController.effectController(forIndex: idx)!
        effectController.wetDryMix = slider.value * 100
    }
}

// MARK: - Track Cell Class

class TrackCell: UITableViewCell {
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    weak var delegate: TrackCellDelegate?
    
    @IBAction func muteButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
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

// MARK: - Effect Cell Class

class EffectCell: UITableViewCell {
    @IBOutlet weak var effectNameLabel: UILabel!
    @IBOutlet weak var mixSlider: UISlider!
    
    weak var delegate: EffectCellDelegate?
    
    @IBAction func mixSliderChanged(_ sender: UISlider) {
        delegate?.effectCell(self, didChangeMixSlider: sender)
    }
}

// MARK: - Effect Cell Delegate Protocol Definition

protocol EffectCellDelegate: class {
    func effectCell(_ effectCell: EffectCell, didChangeMixSlider slider: UISlider)
}

