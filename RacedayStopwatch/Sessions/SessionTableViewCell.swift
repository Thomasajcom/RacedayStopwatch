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
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var fastestDriverNameLabel: UILabel!
    @IBOutlet weak var bestLapTimeLabel: UILabel!
    @IBOutlet weak var bestLapSpeedLabel: UILabel!
    @IBOutlet weak var numberOfLapsLabel: UILabel!
    @IBOutlet weak var timeOnTrackLabel: UILabel!
    @IBOutlet weak var driverImage: UIImageView!
    
    
    
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
        
        if let track = session.onTrack {
            trackNameLabel.text = track.name
            timeOnTrackLabel.text = String(session.timeOnTrack)
            dateLabel.text = dateFormatter.string(from: session.sessionDateAndTime as Date)
        }else {
            trackNameLabel.text = dateFormatter.string(from: session.sessionDateAndTime as Date)
            timeOnTrackLabel.isHidden = true
            dateLabel.isHidden = true
        }
        //if the session does not have  a fastest driver, it will not have a best lap time / speed either
        if let fastestDriver = session.fastestDriver {
            fastestDriverNameLabel.text = fastestDriver.name
            driverImage.image = UIImage(data: (fastestDriver.image as! Data))
            bestLapTimeLabel.text = session.fastestLapTime
            bestLapSpeedLabel.text = session.fastestLapSpeed
        }
        if session.numberOfLaps > 0 {
            numberOfLapsLabel.text = "\(session.numberOfLaps)"
        }else {
            numberOfLapsLabel.isHidden = true
        }
    }
}
