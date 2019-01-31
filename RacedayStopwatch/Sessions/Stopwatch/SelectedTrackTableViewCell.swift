//
//  SelectedTrackTableViewCell.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 31/01/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import UIKit

class SelectedTrackTableViewCell: UITableViewCell {

    static let reuseIdentifier = "SelectedTrackCell"

    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var trackLength: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(_ track: Track){
        trackTitle.text = track.name
        trackLength.text = "\(track.length) meters"
        trackImage.image = UIImage(data: track.image! as Data)
    }
}
