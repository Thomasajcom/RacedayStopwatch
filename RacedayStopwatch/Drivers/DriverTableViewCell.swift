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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        numberLabel.layer.cornerRadius = 10
        numberLabel.layer.masksToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setup(with driver: Driver){
        nameLabel.text = driver.name
        numberLabel.text = "#\(driver.number)"
        driverImage.image = UIImage(data: driver.image as Data)
        
        self.selectionStyle = .none
    }
}
