//
//  Double.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 18/02/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import Foundation

public extension Double{
    /// Function to display time elapsed since reference date in a string with minutes, seconds and miliseconds
    ///
    /// - Parameter self: Time since reference date
    /// - Returns: A formatted string showing minutes, seconds and miliseconds
    func laptimeToString() -> String{
        let formatter                   = NumberFormatter()
        formatter.numberStyle           = .none
        formatter.minimumIntegerDigits  = 2
        
        var newTime     = self//Date().timeIntervalSinceReferenceDate - self
        let minutes     =  UInt8(newTime / 60.0)
        newTime         -= (TimeInterval(minutes) * 60)
        let seconds     = UInt8(newTime)
        newTime         -= TimeInterval(seconds)
        let miliseconds = UInt64(newTime * 1000)
        
        var returnString                = formatter.string(from: minutes as NSNumber)! + ":" + formatter.string(from: seconds as NSNumber)!
        formatter.minimumIntegerDigits  = 3
        returnString                    = returnString + Constants.decimalSeparator + formatter.string(from: miliseconds as NSNumber)!
        return returnString
    }
    
    func fromMilesToMeters() -> Double{
        return self*1609.344
    }
    
    func fromMetersToMiles() -> Double{
        return self/1609.344
    }
    
    func mphToKmh() -> Double{
        return self*1.609344
    }
    func kmhToMph() -> Double{
        return self/1.609344
    }
    func milesToKm() -> Double{
        return 0.0
    }
    func kmToMiles() -> Double{
        return 0.0
    }
    var noDecimals:String {
        return String(format: "%.0f", self)
    }
    var twoDecimals:String {
        return String(format: "%.2f", self)
    }
    var fourDecimals:String {
        return String(format: "%.4f", self)
    }
}

