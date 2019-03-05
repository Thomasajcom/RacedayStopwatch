//
//  TrackTableViewCell.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 01/03/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import UIKit

class TrackTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "trackCell"


    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackLength: UILabel!
    @IBOutlet weak var lapRecordLabel: UILabel!
    @IBOutlet weak var lapRecordHolder: UILabel!
    @IBOutlet weak var lapRecordTime: UILabel!
    @IBOutlet weak var trackImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(_ track: Track){
        trackName.text      = track.name
        trackImage.image    = UIImage(data: track.image!)
        if Constants.defaults.bool(forKey: Constants.defaults_metric_key){
            trackLength.text                = String(track.length.noDecimals) + " " + Constants.LENGTH_UNIT_METERS
        }else{
            trackLength.text                = String(Double(track.length).fromMetersToMiles().threeDecimals ) + " " + Constants.LENGTH_UNIT_MILES
        }
        if track.trackRecord > 0{
            lapRecordTime.isHidden  = false
            lapRecordTime.text      = track.trackRecord.laptimeToString()
            lapRecordHolder.text    = track.trackRecordHolder!.name
        }else{
            lapRecordTime.isHidden  = true
            lapRecordHolder.text    = "No lap record set. Get out there!"
        }
    }
}
