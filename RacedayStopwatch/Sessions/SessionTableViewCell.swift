//
//  SessionTableViewCell.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 11/02/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import UIKit

class SessionTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "SessionCell"

    //MARK: - Properties
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var fastestDriverName: UILabel!
    @IBOutlet weak var bestLapTime: UILabel!
    @IBOutlet weak var bestLapSpeed: UILabel!
   
    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var fastestDriverLabel: UILabel!
    
    @IBOutlet weak var totalSessionTimeLabel: UILabel!
    @IBOutlet weak var totalSessionTime: UILabel!
    @IBOutlet weak var numberOfLaps: UILabel!
    @IBOutlet weak var distanceDriven: UILabel!
    
    var sessionWithTrack = true

    override func prepareForReuse() {
        date.isHidden                   = false
        driverImage.isHidden            = false
        fastestDriverLabel.isHidden     = false
        fastestDriverName.isHidden      = false
        bestLapTime.isHidden            = false
        bestLapSpeed.isHidden           = false
        totalSessionTimeLabel.isHidden  = false
        totalSessionTime.isHidden       = false
        numberOfLaps.isHidden           = false
        distanceDriven.isHidden         = false
    }
    
    //setup a session cell
    func setup(with session: Session) {
        setupDate(for: session.sessionDateAndTime!)
        setupTrack(track: session.onTrack)
        setupFastestDriver(with: session.fastestDriver, in: session)
    }
    
    func setupDate(for sessionDate: Date){
        //consider turning this into an extension of DateFormatter()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale    = Locale.current
        date.text = dateFormatter.string(from: sessionDate)
    }
    
    func setupTrack(track: Track?){
        if let track = track {
            trackName.text = track.name
        }else {
            sessionWithTrack    = false
            trackName.text      = date.text!
            date.isHidden       = true
        }
    }
    
    func setupFastestDriver(with driver: Driver?, in session: Session){
        
        guard let fastestDriver = driver else {
            driverImage.image           = nil
            driverImage.isHidden        = true
            fastestDriverLabel.isHidden = true
            fastestDriverName.isHidden  = true
            bestLapTime.isHidden        = true
            bestLapSpeed.isHidden       = true
            totalSessionTimeLabel.isHidden   = true
            totalSessionTime.isHidden        = true
            numberOfLaps.isHidden       = true
            distanceDriven.isHidden     = true
            return
        }
        driverImage.image = UIImage(data: fastestDriver.image!)
        driverImage.layer.cornerRadius  = Constants.cornerRadius
        driverImage.layer.masksToBounds = true
        fastestDriverLabel.attributedText = NSAttributedString(string: Constants.SESSION_FASTEST_DRIVER, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        fastestDriverName.text = fastestDriver.name
        bestLapTime.text = session.fastestLapTime.laptimeToString()
        numberOfLaps.text = String(session.numberOfLaps) + Constants.SESSION_LAP

        let calculatedDistanceDriven = Double(session.numberOfLaps) * session.onTrack!.length
        if sessionWithTrack {            
            if Constants.defaults.bool(forKey: Constants.defaults_metric_key){
                bestLapSpeed.text = String(Double(session.fastestLapSpeed).twoDecimals) + Constants.SPEED_UNIT_KMH
                distanceDriven.text = String(calculatedDistanceDriven.noDecimals) + Constants.LENGTH_UNIT_METERS
            }else{
                bestLapSpeed.text = String(Double(session.fastestLapSpeed).kmhToMph().twoDecimals) + Constants.SPEED_UNIT_MPH
                distanceDriven.text = String(Double(calculatedDistanceDriven).fromMetersToMiles().fourDecimals) + Constants.LENGTH_UNIT_MILES
            }
            totalSessionTimeLabel.attributedText = NSAttributedString(string: Constants.SESSION_TIME_ON_TRACK, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
            totalSessionTime.text = Double(session.totalSessionTime).laptimeToString()
            
        }else{
            totalSessionTimeLabel.isHidden  = true
            totalSessionTime.isHidden       = true
            distanceDriven.isHidden         = true
            bestLapSpeed.isHidden           = true
        }
    }
}
