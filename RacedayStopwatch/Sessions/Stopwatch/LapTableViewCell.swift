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
        driverNameLabel.text    = lapInfo.driver.name
        driverImage.image       = UIImage(data: (lapInfo.driver.image)!)
        speedLabel.text         = String(lapInfo.speed) + " " + Constants.SPEED_UNIT
        timeLabel.text          = lapInfo.lapTime.laptimeToString()
        lapNumberLabel.text     = Constants.LAP + " " + String(lapInfo.lapNumber)
    }

}
