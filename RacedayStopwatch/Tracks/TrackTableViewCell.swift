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
    
    func setup(_ track: Track){
        trackName.text      = track.name
        trackImage.image    = UIImage(data: track.image!)
        trackImage.clipsToBounds = true
        if Constants.defaults.bool(forKey: Constants.defaults_metric_key){
            trackLength.text                = String(track.length.noDecimals) + " " + Constants.LENGTH_UNIT_METERS
        }else{
            trackLength.text                = String(Double(track.length).fromMetersToMiles().threeDecimals ) + " " + Constants.LENGTH_UNIT_MILES
        }
        if track.trackRecord > 0 && track.trackRecordHolder != nil{
            lapRecordTime.isHidden      = false
            lapRecordHolder.isHidden    = false
            lapRecordTime.text          = track.trackRecord.laptimeToString()
            lapRecordHolder.text        = track.trackRecordHolder!.name
        }else{
            lapRecordHolder.isHidden    = true
            lapRecordTime.text          = Constants.TRACK_NO_RECORD_TIME
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupTheme()
    }
    
    func setupTheme(){
        trackName.textColor         = Theme.activeTheme.highlightFontColor
//        trackName.backgroundColor = Theme.activeTheme.highlightColor
        trackLength.textColor       = Theme.activeTheme.highlightFontColor
        trackLength.backgroundColor = Theme.activeTheme.highlightColor
        backgroundColor             = Theme.activeTheme.foregroundColor
        lapRecordLabel.textColor = Theme.activeTheme.secondaryFontColor
        lapRecordHolder.textColor = Theme.activeTheme.mainFontColor
        lapRecordTime.textColor = Theme.activeTheme.mainFontColor
    }
}
