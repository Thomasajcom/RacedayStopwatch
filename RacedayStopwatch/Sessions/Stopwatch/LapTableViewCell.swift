//
//  LapTableViewCell.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 09/11/2018.
//  Copyright © 2018 Appbryggeriet. All rights reserved.
//

import UIKit

class LapTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "LapCell"

    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var lapNumberLabel: UILabel!
    
    override func prepareForReuse() {
        driverNameLabel.text    = nil
        driverImage.image       = nil
        timeLabel.text          = nil
        speedLabel.text         = nil
        lapNumberLabel.text     = nil
    }
    
    func setup(with lapInfo: Lap){
        if let driver = lapInfo.driver {
            driverNameLabel.text    = driver.name
            driverImage.image       = UIImage(data: (driver.image)!)
            timeLabel.text          = lapInfo.lapTime.laptimeToString()
            lapNumberLabel.text     = Constants.LAP + " " + String(lapInfo.lapNumber)
        }else{
            driverNameLabel.text    = Constants.LAP + " " + String(lapInfo.lapNumber)
            driverImage.isHidden    = true
            timeLabel.text          = lapInfo.lapTime.laptimeToString()
            lapNumberLabel.isHidden = true
        }
        if lapInfo.speed > 0{
            if Constants.defaults.bool(forKey: Constants.defaults_metric_key){
                speedLabel.text         = String(lapInfo.speed) + " " + Constants.SPEED_UNIT_KMH
            }else{
                speedLabel.text         = String(Double(lapInfo.speed).kmhToMph()) + " " + Constants.SPEED_UNIT_MPH
            }
        }else{
            speedLabel.isHidden = true
        }
        
    }

}
