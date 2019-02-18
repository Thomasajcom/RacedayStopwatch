//
//  Constants.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 14/02/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import Foundation

struct Constants{
    //MARK: - Timer
    #warning("internationalize this")
    static let LAP_RECORD_LABEL         = "Lap Record Holder"
    static let LAP_RECORD_HOLDER_NONE   = "No lap record found."
    //check userDefaults, return metric or imperial based on that
    static let LENGTH_UNIT      = "Meters"
    
    static let NO_TRACK_TITLE   = "No Track Selected"
    static let NO_TRACK         = "No track selected, unable to start timer. You must select a track for the session."
    static let NO_DRIVER_TITLE  = "No Driver Selected"
    static let NO_DRIVER        = "There are no participating drivers, unable to start timer. You need atleast one driver."
    
    static let BUTTON_START     = "START"
    static let BUTTON_STOP      = "STOP"
    static let BUTTON_LAP       = "LAP"
    
    //MARK: - Track Select
    static let TRACK_SELECT_TITLE           = "Select Track"
    static let TRACK_SELECT_DISMISS_BUTTON  = "OKAY"
    
    //MARK: - Alert
    static let ALERT_CANCEL     = "Cancel"
}
