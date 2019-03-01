//
//  Lap.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 14/02/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import Foundation


/// NOTE: lapTime is stored as a double in seconds by using TimeSinceReferenceDate - startOfLap
/// Speed is stored as km/h
struct Lap{
    var driver: Driver?
    var lapNumber: Int
    var lapTime: Double
    var speed: Int
}
