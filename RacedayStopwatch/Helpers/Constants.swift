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
    static let defaults_launched_before = "LaunchedBefore"
    static let defaults_dark_mode       = "DarkMode"
    
    //AdMob ID
    static let ADMOB_ID_TEST                = "ca-app-pub-3940256099942544~1458002511"
    static let ADMOB_ID_TEST_INTERSTITIAL   = "ca-app-pub-3940256099942544/4411468910"
    static let ADMOB_ID_PRODUCTION          = "ca-app-pub-8190128329666781~9045362499"
    static let ADMOB_ID_DRIVERS             = "ca-app-pub-8190128329666781/5522541147"
    static let ADMOB_ID_TRACKS              = "ca-app-pub-8190128329666781/6696678553"
    static let ADMOB_ID_SESSIONSAVED        = "ca-app-pub-8190128329666781/4126355537"
    
    //iAP
    static let KEYCHAIN_SERVICE      = "no.appbryggeriet.racedaystopwatch.iapService"
    static let IAP_REMOVE_ADS_ID     = "no.Appbryggeriet.RacedayStopwatch.RemoveAds"
    static let IAP_REMOVE_LIMITS_ID  = "no.Appbryggeriet.RacedayStopwatch.RemoveLimits"
    static let IAP_REMOVE_ALL_ID    = "no.Appbryggeriet.RacedayStopwatch.RemoveAll"
    private static let productIdentifiers: Set<ProductIdentifier> = [Constants.IAP_REMOVE_ADS_ID, IAP_REMOVE_LIMITS_ID,IAP_REMOVE_ALL_ID]
    public static let store = IAPHelper(productIds: Constants.productIdentifiers)
    
    
    static let IAP_TRACK_LIMIT      = 2
    static let IAP_DRIVER_LIMIT     = 3
    static let IAP_SESSION_LIMIT    = 10
    
    static let IAP_LIMIT_REACHED_TITLE  = "Limit Reached"
    static let IAP_LIMIT_REACHED_BODY   = "Remove limit on Tracks/Drivers by making a purchase on the settings page."
    
    static let AD_BANNER_FREQUENCY_TRACKS       = 2
    static let AD_BANNER_FREQUENCR_DRIVERS      = 3
    static let AD_BANNER_FREQUENCY_SESSIONS     = 4
    
    static let IAP_CELL_BUY_BUTTON          = "Buy"
    static let IAP_CELL_PRICE_NOT_AVAILABLE = "Not available"
    
    //Build info, used in About footer
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
    static let DRIVER_ALERT_DELETE_TITLE    = "Delete Driver"
    static let DRIVER_ALERT_DELETE_BODY     = "Do you want to delete this driver? This can not be undone."
    
    //MARK: - Tracks
    static let TRACK_NAME_PLACEHOLDER       = "Enter Track Name"
    static let TRACK_LENGTH_PLACEHOLDER     = "Length in "
    //check userDefaults for metric or imperial
    static let TRACK_LENGTH_UNIT_METERS     = "meters"
    static let TRACK_LENGTH_UNIT_MILES      = "miles"
    
    
    static let TRACK_ALERT_ADD_TRACK_TITLE  = "Add Track"
    static let TRACK_ALERT_DELETE_TITLE     = "Delete Track"
    static let TRACK_ALERT_DELETE_BODY      = "Do you want to delete this track? This can not be undone."
    static let TRACK_RESET_TITLE            = "RESET"
    static let TRACK_RESET_BODY             = "This will reset the track record."
    static let TRACK_NO_RECORD_TIME         = "No lap record set. Get out there!"
    
    //MARK: - Session
    static let SESSION_ALERT_DELETE_TITLE   = "Delete Session"
    static let SESSION_ALERT_DELETE_BODY    = "Do you want to delete this session? This can not be undone."
    //NEW SESSION
    static let SESSION_DRIVER_SELECT_TITLE      = "Select Driver"
    static let SESSION_WITHOUT_TRACK            = "No Track"
    static let SESSION_CUSTOM_LENGTH            = "Enter Custom Length (optional)"
    static let SESSION_WITHOUT_DRIVER           = "No Drivers"
    static let SESSION_TRACK_ERROR_TITLE        = "Track Error"
    static let SESSION_TRACK_ERROR_BODY         = "Either select a track, or turn on the No Track Switch."
    static let SESSION_DRIVER_ERROR_TITLE       = "Driver Error"
    static let SESSION_DRIVER_ERROR_BODY        = "Either select a Driver, or turn on the No Driver Switch."
    static let NEW_SESSION_TIMER_ONLY_TITLE     = "BASIC TIMER"
    
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
    
    static let LAPTIME_NOT_STARTED  = "00:00"+decimalSeparator+"000"
    static let SPEED_UNIT_KMH       = "KM/H"
    static let SPEED_UNIT_MPH       = "MPH"
    

    static let LAP = "Lap"
    
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
    static let ALERT_OK         = "Ok"
    
    //MARK: - SETTINGS
    static let SETTINGS_DEFAULT_HEADER      = "Defaults"
    static let SETTINGS_IAP_HEADER          = "Store"
    static let SETTINGS_THEME_HEADER        = "Themes"
    static let SETTINGS_DARK_MODE_LABEL     = "Dark Mode"
    static let SETTINGS_IMP_OR_METRIC_LABEL = "Measurement Units"
    static let SETTINGS_IMPERIAL_LABEL      = "Imperial"
    static let SETTINGS_METRIC_LABEL        = "Metric"
    
    static let SETTINGS_IAP_RESTORE         = "Restore Purchases"
    static let SETTINGS_IAP_REMOVE_ALL      = "Remove ads and limits"
    static let SETTINGS_IAP_REMOVE_ADS      = "Remove ads"
    static let SETTINGS_IAP_REMOVE_LIMITS   = "Remove limits"
    
    
}
