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
    
    @IBOutlet weak var timeOnTrackLabel: UILabel!
    @IBOutlet weak var timeOnTrack: UILabel!
    @IBOutlet weak var numberOfLaps: UILabel!
    @IBOutlet weak var distanceDriven: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //setup a session cell
    func setup(with session: Session) {
        //consider turning this into an extension of DateFormatter()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        var trackLength:Int16 = 0
        if let track = session.onTrack {
            trackLength = track.length
            trackName.text = track.name
            timeOnTrackLabel.text = String(session.timeOnTrack)
            date.text = dateFormatter.string(from: session.sessionDateAndTime as Date)
        }else {
            trackName.text = dateFormatter.string(from: session.sessionDateAndTime as Date)
            timeOnTrackLabel.isHidden = true
            date.isHidden = true
        }
        //if the session does not have  a fastest driver, it will not have a best lap time / speed either
        if let fastestDriver = session.fastestDriver {
            driverImage.image = UIImage(data: (fastestDriver.image as! Data))
            #warning("internationalize this")
            fastestDriverLabel.attributedText = NSAttributedString(string: "Fastest Driver", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
            fastestDriverName.text = fastestDriver.name
            bestLapTime.text = session.fastestLapTime
            #warning("create extension ToMilesPrHour // From MilesPrHour and save everything in km/t, then check what userPref wants here and calculate accordingly")
            bestLapSpeed.text = "\(session.fastestLapSpeed) km/t"
            #warning("internationalize this")
            timeOnTrackLabel.attributedText = NSAttributedString(string: "Track Time", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
            #warning("fetch the correct data for these")
            timeOnTrack.text = "58 minutes"
            numberOfLaps.text = "\(session.numberOfLaps) laps"
            distanceDriven.text = "\(session.numberOfLaps*trackLength  ) meters"
        }else {
            //hides all info related to the fastest driver in the session
            fastestDriverLabel.isHidden = true
            fastestDriverName.isHidden  = true
            bestLapTime.isHidden        = true
            bestLapSpeed.isHidden       = true
            timeOnTrackLabel.isHidden   = true
            timeOnTrack.isHidden        = true
            numberOfLaps.isHidden       = true
            distanceDriven.isHidden     = true
        
        }
    }
}
