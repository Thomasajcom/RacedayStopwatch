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
    @IBOutlet weak var trackLengthLabel: UILabel!
    @IBOutlet weak var lapRecordLabel: UILabel!
    @IBOutlet weak var lapRecordHolder: UILabel!
    @IBOutlet weak var lapRecordTime: UILabel!
    
    @IBOutlet weak var lapTableview: UITableView!
    @IBOutlet weak var driverCollectionView: UICollectionView!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var lapButton: UIButton!
    
    @IBOutlet weak var addDriverButton: UIButton!
    
    //participatingDrivers will always be atleast 1 - the first "add driver" cell.
    var participatingDrivers = [Driver]()
    
    // TODO:  - Future Patch: Add the option of setting a selectedTrack by default to UserDefaults
    var selectedTrack: Track?{
        didSet{
            trackNameLabel.text = selectedTrack!.name
            trackLengthLabel.text = String(selectedTrack!.length)+" meters"
            
            // TODO: - Internationalize this
            lapRecordLabel.text = "Lap Record"
            if let recordHolderName = selectedTrack!.trackRecordHolder?.name, let trackRecord = selectedTrack!.trackRecord{
                lapRecordHolder.text = recordHolderName
                lapRecordTime.text = trackRecord
            }else{
                lapRecordLabel.isHidden = true
                lapRecordHolder.isHidden = true
                lapRecordTime.isHidden = true
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        driverCollectionView.delegate = self
        driverCollectionView.dataSource = self
        
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
            }
        }else if segue.identifier == "SelectDriverSegue" {
            if let vc = segue.destination as? DriverSelectorViewController{
                vc.driverSelectorDelegate = self
            }
        }
    }
    
    // MARK: - Add Driver / Track
    @IBAction func addDriver(_ sender: UIButton) {
        
    }
    // MARK: - TIMER
    @IBAction func startTimer(_ sender: UIButton) {
    }
    @IBAction func lapTimer(_ sender: UIButton) {
    }
}

extension TimerViewController: TrackSelectorViewControllerDelegate{
    func selected(track: Track) {
        selectedTrack = track
    }
}

extension TimerViewController: DriverSelectorViewControllerDelegate{
    func selected(driver: Driver) {
        participatingDrivers.append(driver)
        driverCollectionView.reloadData()
    }
}

extension TimerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return participatingDrivers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = driverCollectionView.dequeueReusableCell(withReuseIdentifier: DriverCollectionViewCell.reuseIdentifier, for: indexPath) as! DriverCollectionViewCell
        cell.setup(title: participatingDrivers[indexPath.row].name, image: UIImage(data: participatingDrivers[indexPath.row].image as Data)! )
        return cell
    }
}
