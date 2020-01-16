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
    
    /// current audio project, publicly readonly. use setAudioProject to set
    private(set) public var audioProject: AudioProject?
    
    
    /// set audio project
    // TODO: throw?
    public func setAudioProject(_ audioProject: AudioProject) {
        self.audioProject = audioProject
     
        setUpNodes()
    }
    
    public func play() {
        if !audioEngine.isRunning {
            // TODO: better exception handling
            try! audioEngine.start()
            
            var startTime: AVAudioTime? = nil
            
            for player in trackContainers {
                
                if startTime == nil {
                    let delayTime = 0.1
                    let outputFormat = player.playerNode.outputFormat(forBus: 0)
                    let startSampleTime = player.playerNode.lastRenderTime!.sampleTime + AVAudioFramePosition(delayTime * outputFormat.sampleRate)
                    startTime = AVAudioTime(sampleTime: startSampleTime, atRate: outputFormat.sampleRate)
                    
                }
                player.playerNode.scheduleBuffer(player.buffer, at: nil, options: [.loops], completionHandler: nil)
                player.playerNode.play(at: startTime)
            }
            
        }
    }
    
    public func stop() {
        for player in trackContainers {  player.playerNode.stop() }
        audioEngine.stop()
    }
    
    public func trackController(forIndex index: Int) -> TrackController? {
        if index >= trackContainers.count { return nil }
        return trackContainers[index]
    }
    
    // MARK: - Private
    
    private var audioEngine = AVAudioEngine()
    
    private var trackContainers = [TrackContainer]()
    
    private func setUpNodes() {
        
        clearPlayerNodes()
        
        setUpTracks()
        
    }

    /// Detach current player nodes from the engine and clear the playerNodes array
    private func clearPlayerNodes() {
        for player in trackContainers {
            audioEngine.detach(player.playerNode)
            audioEngine.detach(player.mixerNode)
        }
        trackContainers = [TrackContainer]()
    }
    
    private func setUpTracks() {
        guard let audioProject = audioProject else {
            return
        }
        for trackFile in audioProject.tracks {
            guard let trackURL = Bundle.main.url(forResource: trackFile, withExtension: "wav") else {
                // TODO: more elegant error handling
                fatalError("Could not obtail url for track: \(trackFile)")
            }
            //print("trackURL: \(String(describing: trackURL))")
            let player = TrackContainer()
            // TODO: more elegant error handling:
            let audioFile = try! AVAudioFile(forReading: trackURL)
            player.buffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: AVAudioFrameCount(audioFile.length))
            do {
                try audioFile.read(into: player.buffer)
            } catch {
                // TODO: more elegant error handling
                fatalError("Error reading audio file \(trackFile) into buffer: \(error)")
            }
            trackContainers.append(player)
            audioEngine.attach(player.playerNode)
            audioEngine.attach(player.mixerNode)
            audioEngine.connect(player.playerNode,
                                to: player.mixerNode,
                                format: player.buffer.format)
            audioEngine.connect(player.mixerNode,
                                to: audioEngine.mainMixerNode,
                                format: player.buffer.format)
        }
    }
}

// MARK - Track Container

/// This is a fileprivate class that conforms to the public TrackController protocol. Used internally to manage AVAudioNodes per-track, exposed publically to provide volume, mute, (etc?)
fileprivate class TrackContainer: TrackController {
    var playerNode = AVAudioPlayerNode()
    var buffer: AVAudioPCMBuffer!
    var mixerNode = AVAudioMixerNode()
    
    // conform to TrackController:
    
    var volume: Float = 1 {
        didSet {
            if !mute { mixerNode.volume = volume }
        }
    }
    
    var mute: Bool = false {
        didSet {
            mixerNode.volume = mute ? 0 : volume
        }
    }
}

// MARK: - TrackController protocol definition

public protocol TrackController: class {
    var volume: Float { get set }
    var mute: Bool { get set }
}
