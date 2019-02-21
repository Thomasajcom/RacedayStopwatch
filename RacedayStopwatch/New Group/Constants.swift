//
//  Constants.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 14/02/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import Foundation

struct Constants{
    static let decimalSeparator = NSLocale.current.decimalSeparator ?? "."
    
    //MARK: - Strings
    //MARK: - Timer
    #warning("internationalize this")
    static let LAP_RECORD_LABEL         = "Lap Record Holder"
    static let LAP_RECORD_HOLDER_NONE   = "No lap record found."
    //check userDefaults, return metric or imperial based on that
    static let LENGTH_UNIT      = "Meters"
    
    static let NO_TRACK_TITLE   = "No Track Selected"
    static let NO_TRACK_BODY    = "No track selected, unable to start timer. You must select a track for the session."
    static let NO_DRIVER_TITLE  = "No Driver Selected"
    static let NO_DRIVER_BODY   = "There are no participating drivers, unable to start timer. You need atleast one driver."
    
    static let BUTTON_START     = "START"
    static let BUTTON_STOP      = "STOP"
    static let BUTTON_LAP       = "LAP"
    
    static let LAPTIME_NOT_STARTED = "00:00"+decimalSeparator+"000"
    //check userDefaults, return metric or imperial based on that

    static let SPEED_UNIT   = "km/h"
    static let LAP          = "Lap"
    
    //saving a session
    static let TIMER_RUNNING_TITLE  = "Timer still running"
    static let TIMER_RUNNING_BODY   = "You have to stop the timer before trying to save."
    static let NO_LAPS_TITLE        = "No laps recorded"
    static let NO_LAPS_BODY         = "There is nothing to save."
    
    //MARK: - Track Select
    static let TRACK_SELECT_TITLE           = "Select Track"
    static let TRACK_SELECT_DISMISS_BUTTON  = "OKAY"
    
    //MARK: - Alert
    static let ALERT_CANCEL     = "Cancel"
    static let ALERT_SAVED      = "Ok"
}
