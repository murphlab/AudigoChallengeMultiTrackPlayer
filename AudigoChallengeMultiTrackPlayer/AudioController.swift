//
//  AudioController.swift
//  AudigoChallengeMultiTrackPlayer
//
//  Created by Ken Murphy on 1/15/20.
//  Copyright © 2020 Ken Murphy. All rights reserved.
//

import UIKit
import AVFoundation

/// Manages all of our audio playback functions
class AudioController: NSObject {
    
    override init() {
        super.init()
        initSession()
    }
    
    // MARK: - Private init methods
    
    private func initSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback)
        } catch {
            fatalError("Error setting audio session category: \(error.localizedDescription)")
        }
        
        // TODO: set sample rate?
        
        do {
            try session.setActive(true, options: [])
            print("Audio session active")
        } catch {
            fatalError("Could not activeate audio session")
        }
    }
    
    // MARK: - Public
    
    /// The current audio project being managed
    public var audioProject: AudioProject? {
        didSet {
            print("Set audio project: \(String(describing: audioProject))")
        }
    }

}
