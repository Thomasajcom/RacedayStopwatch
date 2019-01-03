//
//  TrackTableViewCell.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 13/11/2018.
//  Copyright © 2018 Appbryggeriet. All rights reserved.
//

import UIKit

class TrackTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TrackSelector"
    @IBOutlet weak var tracknameLabel: UILabel!
    @IBOutlet weak var trackLengthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
