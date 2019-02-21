//
//  DriverCollectionViewCell.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 05/02/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import UIKit

class DriverCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "DriverCell"
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    

    func setup(title: String, image: UIImage){
        cellTitle.text = title
        cellImage.layer.cornerRadius = 10
        cellImage.layer.masksToBounds = true
        cellImage.image = image
        timerLabel.text = Constants.LAPTIME_NOT_STARTED
    }
    
    func updateLabels(lapTime: Double){
        timerLabel.text = lapTime.laptimeToString()
    }
}
