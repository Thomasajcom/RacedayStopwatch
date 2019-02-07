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
    
    
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var milisecondsLabel: UILabel!
    
    @IBOutlet weak var lapTableview: UITableView!
    @IBOutlet weak var driverCollectionView: UICollectionView!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var lapButton: UIButton!
    
    @IBOutlet weak var addDriverButton: UIButton!
    
    var participatingDrivers =  [Driver]()
    
    var laps = [Lap]()
    var session = Session()
    
    weak var timer: Timer?
    var timerEnabled: Bool = false
    var startTime: Double = 0
    var time: Double = 0
    var minutes: UInt8 = 00
    var seconds: UInt8 = 00
    var miliseconds: UInt64 = 000
    
    // TODO:  - Future Patch: Add the option of setting a selectedTrack by default to UserDefaults
    var selectedTrack: Track?{
        didSet{
            session.onTrack = selectedTrack

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
        session = Session(context: CoreDataService.context)
        session.sessionDateAndTime = Date() as NSDate

        driverCollectionView.delegate = self
        driverCollectionView.dataSource = self
        
        startButton.layer.cornerRadius = 10
        startButton.layer.masksToBounds = true
        lapButton.layer.cornerRadius = 10
        lapButton.layer.masksToBounds = true
        
        lapTableview.delegate = self
        lapTableview.dataSource = self
        
        let date = Date()
        let formatter = DateFormatter()
        //TODO: - Internationalize this
        formatter.dateFormat = "dd.MM.yyyy"
        let todayString = formatter.string(from: date)
//        self.navigationController?.title = todayString


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

    @IBAction func save(_ sender: UIBarButtonItem) {
        //going home
        //needs checks for a lot of stuff:
        // - timer still running? is there somthing to save?
        print("Trying to save?")
//                    CoreDataService.saveContext()
        //        self.navigationController?.popToRootViewController(animated: true)
//        performSegue(withIdentifier: "UnwindToSessionsSegue", sender: self)
    }
    // MARK: - TIMER
    @IBAction func startTimer(_ sender: UIButton) {
        print("Starting the timer, button should be changed to STOP")
        timerEnabled.toggle()
        
        if(timerEnabled){
            sender.setTitle("STOP", for: .normal)
            sender.backgroundColor = .red
            
            startTime = Date().timeIntervalSinceReferenceDate
            timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: .common) //to make sure that user interaction with the screen does not interferes with the timer
            
        }else{
            sender.setTitle("Start", for: .normal)
            sender.backgroundColor = UIColor(red: (79.0/255.0), green: (143.0/255.0), blue: (0.0/255.0), alpha: 1)
            print("Killing the timer!")
            timer!.invalidate()
        }
    }
    
    fileprivate func lap(by driver: Driver?, time: String) {
        //find the lapnumber for the current driver based on occurences in the Laps array
        let lapNumber = laps.filter {$0.driver == driver}
        //create a new instance of the Lap struct and add it to the array of Laps
        let newLap = Lap(driver: driver, lapNumber: lapNumber.count+1, lapTime: time, speed: 0) //add 1 to lapNumber as there is no "lap 0"
        
        laps.append(newLap)
        lapTableview.reloadSections([0], with: .automatic)
        lapTableview.scrollToRow(at: IndexPath(row: laps.count-1, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
    }
    
    @IBAction func lapTimer(_ sender: UIButton) {
        lap(by: nil, time: "\(minutes):\(seconds):\(miliseconds)")
    }
    @objc func updateTimer(){
        //apparently this needs to be redone
        // Calculate total time since timer started in seconds
        time = Date().timeIntervalSinceReferenceDate - startTime
        
        // Calculate minutes
        minutes = UInt8(time / 60.0)
        time -= (TimeInterval(minutes) * 60)
        // Calculate seconds
        seconds = UInt8(time)
        time -= TimeInterval(seconds)
        // Calculate milliseconds
        miliseconds = UInt64(time * 1000)
        updateTimerLabels()
    }
    func updateTimerLabels(){
        minutesLabel.text = String(format: "%02d", minutes)
        secondsLabel.text = String(format: "%02d", seconds)
        milisecondsLabel.text = String(format: "%03d", miliseconds)//change to numberformatter
    }
}

// MARK: - extensions track/driver delegates
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

//MARK: - TableView
extension TimerViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LapTableViewCell.reuseIdentifier, for: indexPath) as! LapTableViewCell
        cell.driverNameLabel.text = laps[indexPath.row].driver?.name ?? "Default"
        cell.speedLabel.text = "\(laps[indexPath.row].speed) km/t"
        cell.timeLabel.text = laps[indexPath.row].lapTime
        cell.lapNumberLabel.text = "\(laps[indexPath.row].lapNumber)"
        return cell
    }
}

//MARK: - CollectionView
extension TimerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return participatingDrivers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = driverCollectionView.dequeueReusableCell(withReuseIdentifier: DriverCollectionViewCell.reuseIdentifier, for: indexPath) as! DriverCollectionViewCell
        cell.setup(title: participatingDrivers[indexPath.row].name, image: UIImage(data: participatingDrivers[indexPath.row].image as Data)! )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        lap(by: participatingDrivers[indexPath.row], time: "\(minutes):\(seconds):\(miliseconds)")
    }
}

struct Lap{
    var driver: Driver?
    var lapNumber: Int
    var lapTime: String
    var speed: Int
}


//TODO: - the popup showing selectable drivers must be added to an array where they can be removed when selected
// - Check with user if timer should start without track or drivers
// remove ability to flick to previous screen while timer is running
// increase driver window?
// format all timer text correctly
