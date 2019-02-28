//
//  Constants.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 14/02/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import Foundation
import UIKit

struct Constants{
    //GUI
    //consider drawing this for performance increase
    static let cornerRadius: CGFloat = 10
    static let decimalSeparator = NSLocale.current.decimalSeparator ?? "."
    
    //MARK: - Strings
    //MARK: - Driver
    //Add Driver
    static let ADD_DRIVER_LABEL     = "Add Driver"
    static let EDIT_DRIVER_LABEL    = "Edit Driver"
static let ADD_DRIVER_PICTURE_OR_HELMET_LABEL = "Driver Picture or Helmet"
    static let ADD_DRIVER_PICTURE_SEGMENT = "Picture"
    static let ADD_DRIVER_HELMET_SEGMENT = "Helmet"
    static let SAVE_BUTTON_TITLE    = "Save"
    static let DRIVER_NAME_PLACEHOLDER = "Enter a Name"
static let DRIVER_NAME_PLACEHOLDER_ERROR = "ENTER NAME!"
    static let DRIVER_NUMBER_PLACEHOLDER = "Enter a Number"
    static let DRIVER_NUMBER_PLACEHOLDER_ERROR = "ENTER NUMBER!"
    
    static let CAMERA_TITLE = "Camera"
    static let GALLERY_TITLE = "Gallery"
    
    //MARK: - Driver Cell
    static let DRIVER_SESSIONS = "Sessions:"
    static let DRIVER_FASTEST_DRIVER = "Fastest driver:"
    static let DRIVER_FASTEST_DRIVER_TIMER = " times."
    
    //MARK: - Tracks
    static let TRACK_NAME_PLACEHOLDER = "Enter Track Name"
    static let TRACK_LENGTH_PLACEHOLDER = "Length in "
    //check userDefaults for metric or imperial
    static let TRACK_LENGTH_UNIT = "meters"
    
    static let TRACK_ALERT_ADD_TRACK_TITLE = "Add Track"
    static let TRACK_ALERT_DELETE_TITLE = "Delete Track"
    static let TRACK_ALERT_DELETE_BODY = "Do you want to delete this track? This can not be undone."
    
    //MARK: - Session
    //NEW SESSION
    static let SESSION_DRIVER_SELECT_TITLE      = "Select Driver"
    static let SESSION_WITHOUT_TRACK            = "Session Without Track"
    static let SESSION_CUSTOM_LENGTH            = "Enter Custom Length (optional)"
    
    static let SESSION_FASTEST_DRIVER           = "Fastest Driver"
    static let SESSION_LAP                      = " laps"
    static let SESSION_TIME_ON_TRACK            = "Time on Track"
    //MARK: - Timer
    #warning("internationalize this")
    static let TIMER_SELECT_DRIVER      = "Select Driver"
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
    
    static let TIMER_NOT_RUNNING_TITLE  = "Timer Not Active"
    static let TIMER_NOT_RUNNING_BODY   = "Unable to lap when the timer isn't running."
    
    //saving a session
    static let TIMER_RUNNING_TITLE          = "Timer still running"
    static let TIMER_RUNNING_BODY           = "You have to stop the timer before trying to save."
    static let NO_LAPS_TITLE                = "No laps recorded"
    static let NO_LAPS_BODY                 = "There is nothing to save."
    static let TIMER_SESSION_SAVED_TITLE    = "Session Saved!"
    static let TIMER_SESSION_SAVED_BODY     = "The session was successfully saved"
    
    //MARK: - Track Select
    static let TRACK_SELECT_TITLE           = "Select Track"
    static let TRACK_SELECT_DISMISS_BUTTON  = "Done"
    
    //MARK: - Alert
    static let ALERT_CANCEL     = "Cancel"
    static let ALERT_SAVED      = "Ok"
}
