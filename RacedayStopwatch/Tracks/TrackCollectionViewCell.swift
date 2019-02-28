//
//  TrackCollectionViewCell.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 29/01/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import UIKit

class TrackCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "trackCell"

    
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackLength: UILabel!
    @IBOutlet weak var lapRecordLabel: UILabel!
    @IBOutlet weak var lapRecordHolder: UILabel!
    @IBOutlet weak var lapRecordTime: UILabel!
    @IBOutlet weak var trackImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(_ track: Track){
        self.layer.cornerRadius     = Constants.cornerRadius
        self.layer.masksToBounds    = false
        trackImage.layer.cornerRadius   = Constants.cornerRadius
        trackImage.layer.masksToBounds  = false
        trackName.text                  = track.name
        trackLength.text                = String(track.length)
        if track.trackRecord > 0{
            lapRecordTime.isHidden  = false
            lapRecordTime.text      = track.trackRecord.laptimeToString()
            lapRecordHolder.text    = track.trackRecordHolder!.name
        }else{
            lapRecordTime.isHidden  = true
            lapRecordHolder.text    = "No lap record set. Get out there!"
        }
        if let mapImage = track.image{
            trackImage.image = UIImage(data: mapImage)
        }else{
            trackImage.image = UIImage(named: "defaultTrack")
        }
    }
}
