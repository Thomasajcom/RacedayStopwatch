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
        print("awakeFromNib i cell")
        //setup radius etc
//        trackImage.layer.cornerRadius = 10
//        trackImage.layer.masksToBounds = false
    }
    
    func setup(_ track: Track){
        trackName.text = track.name
        trackLength.text = "\(track.length)"
        if let trackRecord = track.trackRecord{
            lapRecordTime.text = trackRecord
            lapRecordHolder.text = track.trackRecordHolder?.name
        }else{
            lapRecordTime.isHidden = true
            lapRecordHolder.text = "No lap record set. Get out there!"
        }
    }
}
