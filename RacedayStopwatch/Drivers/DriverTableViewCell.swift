//
//  DriverTableViewCell.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 09/11/2018.
//  Copyright © 2018 Appbryggeriet. All rights reserved.
//

import UIKit

class DriverTableViewCell: UITableViewCell {

    static let reuseIdentifier = "DriverCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var driverImage: UIImageView!
    
    func setup(with driver: Driver){
        numberLabel.layer.cornerRadius  = 10
        numberLabel.layer.masksToBounds = true
        nameLabel.text                  = driver.name
        if let driverNumber = driver.number{
            numberLabel.text        = "#\(driverNumber)"
        }else{
            numberLabel.isHidden    = true
        }
        driverImage.image = UIImage(data: driver.image!)
        
        self.selectionStyle = .none
    }
}
