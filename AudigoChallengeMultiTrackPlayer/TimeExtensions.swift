//
//  TimeExtensions.swift
//  Audigo
//
//  Created by Ken Murphy on 6/15/20.
//  Copyright © 2020 Audigo Labs, Inc. All rights reserved.
//

import Foundation

public extension DispatchTime {
    
    func secondsSince(_ then: DispatchTime) -> Double {
        return Double(self.uptimeNanoseconds - then.uptimeNanoseconds) / 1_000_000_000
    }
    
    static func logSecondsSince(_ then: DispatchTime, label: String) {
        let elapsed = DispatchTime.now().secondsSince(then)
        print("PERFORMANCE: \(label): \(elapsed) seconds")
    }
}

public extension TimeInterval {
    
    var hoursMinutesSecondsTuple: (Int, Int, Int) {
        let seconds = Int(self)
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

    var hoursMinutesSecondsString: String {
        let (hours, minutes, seconds) = hoursMinutesSecondsTuple
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
