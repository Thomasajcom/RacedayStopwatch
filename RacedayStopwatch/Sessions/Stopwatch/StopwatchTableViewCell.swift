//
//  StopwatchTableViewCell.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 09/11/2018.
//  Copyright © 2018 Appbryggeriet. All rights reserved.
//

import UIKit

protocol StopwatchTableViewCellDelegate {
    func startedTimer()
    func newLap()
    func stoppedTimer()
}

class StopwatchTableViewCell: UITableViewCell {
    
    var stopwatchDelegate: StopwatchTableViewCellDelegate!
    
    static let reuseIdentifier = "StopwatchCell"
    
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var milisecondsLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var lapButton: UIButton!
    
    var timerEnabled: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func startButton(_ sender: Any) {
        if (timerEnabled){
            timerEnabled.toggle()
            stopwatchDelegate.stoppedTimer()
        }else{
            timerEnabled.toggle()
            stopwatchDelegate.startedTimer()
            
        }
//        if(!timerEnabled){
//            
//            startButton.setTitle("STOP", for: .normal)
//            startButton.backgroundColor = .red
//        }else if(timerEnabled){
//            stopwatchDelegate.stoppedTimer()
//            startButton.setTitle("Start", for: .normal)
//            startButton.backgroundColor = UIColor(red: (79.0/255.0), green: (143.0/255.0), blue: (0.0/255.0), alpha: 1)
//        }
//        timerEnabled.toggle()
    }
    
    @IBAction func lap(_ sender: Any) {
        stopwatchDelegate.newLap()
    }
}


