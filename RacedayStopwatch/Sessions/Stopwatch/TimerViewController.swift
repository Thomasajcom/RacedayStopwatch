//
//  TimerViewController.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 04/02/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var LapRecordLabel: UILabel!
    @IBOutlet weak var lapRecordHolder: UILabel!
    @IBOutlet weak var lapRecordTime: UILabel!
    
    @IBOutlet weak var lapTableview: UITableView!
    @IBOutlet weak var driverCollectionView: UICollectionView!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var lapButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startButton.layer.cornerRadius = 10
        startButton.layer.masksToBounds = true
        
        lapButton.layer.cornerRadius = 10
        lapButton.layer.masksToBounds = true
        
        
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectTrackSegue" {
            if let vc = segue.destination as? TrackSelectorViewController{
                vc.trackSelectorDelegate = self
                vc.getTracks = true
            }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        }
    }
 
    
    // MARK: - TIMER
    @IBAction func startTimer(_ sender: UIButton) {
    }
    @IBAction func lapTimer(_ sender: Any) {
    }
}

extension TimerViewController: TrackSelectorViewControllerDelegate{
    func selected(track: Track) {
        trackNameLabel.text = track.name
    }
}
