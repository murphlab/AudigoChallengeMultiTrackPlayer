//
//  AudioProject.swift
//  AudigoChallengeMultiTrackPlayer
//
//  Created by Ken Murphy on 1/15/20.
//  Copyright © 2020 Ken Murphy. All rights reserved.
//

import Foundation

/// Single project:
public struct AudioProject: Codable {
    public var tracks: [String]
}

/// Collection of projects:
public typealias AudioProjects = [String: AudioProject]

