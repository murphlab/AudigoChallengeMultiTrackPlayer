//
//  ProjectManager.swift
//  AudigoChallengeMultiTrackPlayer
//
//  Created by Ken Murphy on 1/15/20.
//  Copyright © 2020 Ken Murphy. All rights reserved.
//

import Foundation

/// Utilities for managing project data
public struct ProjectManager {
    
    // load data for all audio projects
    public static func loadAudioProjects() -> AudioProjects? {
        if
            let path = Bundle.main.path(forResource: "AudioProjects", ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path),
            let projects = try? PropertyListDecoder().decode(AudioProjects.self, from: xml)
        {
            return projects
        } else {
            print("Could not obtail audio projets plist file")
            return nil
        }
    }
}
