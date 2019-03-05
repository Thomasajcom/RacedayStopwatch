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
    static let cornerRadius: CGFloat    = 10
    static let decimalSeparator         = NSLocale.current.decimalSeparator ?? "."
    
    //UserDefaults
    static let defaults = UserDefaults.standard
    static let defaults_metric_key      = "Metric"
    static let defaults_launched_before     = "LaunchedBefore"
    
    //used in About footer
    static let Appversion = "CFBundleShortVersionString"
    static let Buildnumber = "CFBundleVersion"
    
    #warning("internationalize this")
    //MARK: - Strings
    //Titles
    static let SESSIONS_TITLE     = "Sessions"
    static let TRACKS_TITLE       = "Tracks"
    static let DRIVERS_TITLE      = "Drivers"
    static let NEW_SESSION_TITLE  = "New Session"
    static let SETTINGS_TITLE     = "Settings"
    //MARK: - Add Item
    //Add Driver
    static let ADD_DRIVER_LABEL                     = "Add Driver"
    static let EDIT_DRIVER_LABEL                    = "Edit Driver"
    static let ADD_DRIVER_PICTURE_OR_HELMET_LABEL   = "Driver Picture or Helmet"
    static let ADD_ITEM_PICTURE_SEGMENT             = "Picture"
    static let ADD_ITEM_HELMETS_SEGMENT             = "Helmets"
    static let SAVE_BUTTON_TITLE                    = "Save"
    static let ITEM_NAME_LABEL                      = "Name"
    static let DRIVER_NAME_PLACEHOLDER              = "Enter a Name"
    static let DRIVER_NAME_PLACEHOLDER_ERROR        = "ENTER NAME!"
    static let DRIVER_NUMBER_LABEL                  = "Number"
    static let DRIVER_NUMBER_PLACEHOLDER            = "Enter a Number"
    static let DRIVER_NUMBER_PLACEHOLDER_ERROR      = "ENTER NUMBER!"
    static let ADD_ITEM_IMAGE_ERROR_TITLE           = "Image Error"
    static let ADD_ITEM_IMAGE_ERROR_BODY            = "Either take a picture, select a photo or choose a pre-defined item from the list."
    
    static let ADD_TRACK_LABEL                      = "Add Track"
    static let EDIT_TRACK_LABEL                     = "Edit Track"
    static let ADD_ITEM_TRACKS_SEGMENT              = "Tracks"
    static let TRACK_LENGTH_LABEL                   = "Track Length"

    
    static let CAMERA_TITLE     = "Camera"
    static let GALLERY_TITLE    = "Gallery"
    //MARK: - Driver
    //MARK: - Driver Cell
    static let DRIVER_SESSIONS              = "Sessions:"
    static let DRIVER_FASTEST_DRIVER        = "Fastest driver:"
    static let DRIVER_FASTEST_DRIVER_TIMER  = " times."
    
    //MARK: - Tracks
    static let TRACK_NAME_PLACEHOLDER       = "Enter Track Name"
    static let TRACK_LENGTH_PLACEHOLDER     = "Length in "
    //check userDefaults for metric or imperial
    static let TRACK_LENGTH_UNIT_METERS     = "meters"
    static let TRACK_LENGTH_UNIT_MILES      = "miles"
    
    
    static let TRACK_ALERT_ADD_TRACK_TITLE  = "Add Track"
    static let TRACK_ALERT_DELETE_TITLE     = "Delete Track"
    static let TRACK_ALERT_DELETE_BODY      = "Do you want to delete this track? This can not be undone."
    
    //MARK: - Session
    //NEW SESSION
    static let SESSION_DRIVER_SELECT_TITLE      = "Select Driver"
    static let SESSION_WITHOUT_TRACK            = "No Track"
    static let SESSION_CUSTOM_LENGTH            = "Enter Custom Length (optional)"
    static let SESSION_WITHOUT_DRIVER           = "No Drivers"
    static let SESSION_TRACK_ERROR_TITLE        = "Track Error"
    static let SESSION_TRACK_ERROR_BODY         = "Either select a track, or turn on the No Track Switch."
    static let SESSION_DRIVER_ERROR_TITLE       = "Driver Error"
    static let SESSION_DRIVER_ERROR_BODY        = "Either select a Driver, or turn on the No Driver Switch."
    
    static let SESSION_FASTEST_DRIVER           = "Fastest Driver"
    static let SESSION_LAP                      = " laps"
    static let SESSION_TIME_ON_TRACK            = "Time on Track"
    static let DRIVER_IS_SELECTED               = "Selected!"
    //MARK: - Timer
    //add driver to session
    static let TIMER_EXIT                   = "Exit"
    static let TIMER_EXIT_MESSAGE           = "This will exit without saving. Are you sure?"
    static let TIMER_ADD_DRIVER_OKBUTTON    = "Add"
    static let TIMER_SELECT_DRIVER          = "Select Driver"
    static let LAP_RECORD_LABEL             = "Lap Record Holder"
    static let LAP_RECORD_HOLDER_NONE       = "No lap record found."
    //check userDefaults, return metric or imperial based on that
    static let LENGTH_UNIT_METERS       = "Meters"
    static let LENGTH_UNIT_MILES        = "Miles"
    
    static let NO_TRACK_TITLE   = "No Track Selected"
    static let NO_TRACK_BODY    = "No track selected, unable to start timer. You must select a track for the session."
    static let NO_DRIVER_TITLE  = "No Driver Selected"
    static let NO_DRIVER_BODY   = "There are no participating drivers, unable to start timer. You need atleast one driver."
    
    static let BUTTON_START     = "START"
    static let BUTTON_STOP      = "STOP"
    static let BUTTON_LAP       = "LAP"
    
    static let LAPTIME_NOT_STARTED = "00:00"+decimalSeparator+"000"
    static let SPEED_UNIT_KMH   = "KM/H"
    static let SPEED_UNIT_MPH   = "MPH"
    

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
    static let ALERT_OK      = "Ok"
    
    //MARK: - SETTINGS
    static let SETTINGS_DEFAULT_HEADER      = "Defaults"
    static let SETTINGS_IAP_HEADER          = "In-App Purchases"
    static let SETTINGS_IMP_OR_METRIC_LABEL = "Measurement Units"
    static let SETTINGS_IMPERIAL_LABEL      = "Imperial"
    static let SETTINGS_METRIC_LABEL        = "Metric"
    
    
}
