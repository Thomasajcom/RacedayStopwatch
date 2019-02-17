//
//  RaceDayTimer.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 14/02/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import Foundation

struct RaceDayTimer{
    var startTime: Double?
    
    var isRunning = false {
        didSet{
            if isRunning{
                self.startTime = Date().timeIntervalSinceReferenceDate
                self.laps = 0
            }else{
                self.startTime = nil
            }
        }
    }
    
    var laps: Int?{
        didSet{
            self.startTime = Date().timeIntervalSinceReferenceDate
        }
    }
}
