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
    
    private static let PROJECTS_RESOURCE_NAME = "AudioProjects"
    private static let PROJECTS_RESOURCE_TYPE = "plist"
    
    // load data for all audio projects
    public static func loadAudioProjects() -> AudioProjects? {
        
        guard let path = Bundle.main.path(forResource: PROJECTS_RESOURCE_NAME, ofType: PROJECTS_RESOURCE_TYPE) else {
            print("ERROR: Could not obtain path for resource: \(PROJECTS_RESOURCE_NAME)")
            return nil
        }
        
        guard let xml = FileManager.default.contents(atPath: path) else {
            print("ERROR: Could not read xml from resource: \(PROJECTS_RESOURCE_NAME)")
            return nil
        }
        
        do {
            let projects = try PropertyListDecoder().decode(AudioProjects.self, from: xml)
            return projects
        } catch {
            print("Exception thrown decoding resource: \(PROJECTS_RESOURCE_NAME): \(error.localizedDescription)")
            return nil
        }
    }
}
