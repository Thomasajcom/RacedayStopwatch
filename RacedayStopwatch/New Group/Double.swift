//
//  Double.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 18/02/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import Foundation

public extension Double{
    
    /// Function to display time since referance date in a string with minutes, seconds and miliseconds
    ///
    /// - Parameter self: Elapsed time since reference date
    /// - Returns: A formatted string showing minutes, seconds and miliseconds
    func fromTimeToString() -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.minimumIntegerDigits = 2
        var newTime = Date().timeIntervalSinceReferenceDate - self
        let minutes =  UInt8(newTime / 60.0)
        newTime -= (TimeInterval(minutes) * 60)
        let seconds = UInt8(newTime)
        newTime -= TimeInterval(seconds)
        let miliseconds = UInt64(newTime * 1000)
        var returnString = formatter.string(from: minutes as NSNumber)! + ":" + formatter.string(from: seconds as NSNumber)!
        formatter.minimumIntegerDigits = 3
        returnString = returnString + ":" + formatter.string(from: miliseconds as NSNumber)!
        return returnString
    }
    
    #warning("add from mphToKmh, from milesToKm, etcetcetc")
    
}
