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
    
    /// current audio project, publically readonly. use setAudioProject to set
    private(set) public var audioProject: AudioProject?
    
    
    /// set audio project
    // TODO: throw?
    public func setAudioProject(_ audioProject: AudioProject) {
        self.audioProject = audioProject
     
        setUpNodes()
    }
    
    // MARK: - Private
    
    private var audioEngine = AVAudioEngine()
    
    private var playerNodes = [PlayerNodeWithBuffer]()
    
    private func setUpNodes() {
        guard let audioProject = audioProject else {
            return
        }
        
        clearPlayerNodes()
        
        for trackFile in audioProject.tracks {
            guard let trackURL = Bundle.main.url(forResource: trackFile, withExtension: "wav") else {
                // TODO: more elegant error handling
                fatalError("Could not obtail url for track: \(trackFile)")
            }
            //print("trackURL: \(String(describing: trackURL))")
            let playerWithBuffer = PlayerNodeWithBuffer()
            // TODO: more elegant error handling:
            let audioFile = try! AVAudioFile(forReading: trackURL)
            playerWithBuffer.buffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: AVAudioFrameCount(audioFile.length))
        }
        
    }
    
    /// Detach current player nodes from the engine and clear the playerNodes array
    private func clearPlayerNodes() {
        for playerNode in playerNodes {
            audioEngine.detach(playerNode.playerNode)
        }
        playerNodes = [PlayerNodeWithBuffer]()
    }
}

/// Container for playerNode + associated buffer
fileprivate class PlayerNodeWithBuffer {
    var playerNode = AVAudioPlayerNode()
    var buffer: AVAudioPCMBuffer!
}
