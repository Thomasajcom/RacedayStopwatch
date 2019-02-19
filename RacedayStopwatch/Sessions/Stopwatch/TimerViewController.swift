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
    
    
    @IBOutlet weak var mainTimerLabel: UILabel!
    
    @IBOutlet weak var lapTableview: UITableView!
    @IBOutlet weak var driverCollectionView: UICollectionView!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var addDriverButton: UIButton!
    
    var participatingDrivers =  [(Driver,RaceDayTimer)]()
    var laps = [Lap]()
    
    weak var mainTimer: Timer?
    var mainTimerEnabled: Bool = false
    var mainTimerStartTime: Double = 0

    
    // TODO:  - Future Patch: Add the option of setting a selectedTrack by default to UserDefaults
    var selectedTrack: Track?{
        didSet{
            trackNameLabel.text     = selectedTrack!.name
            trackLengthLabel.text   = String(selectedTrack!.length)+" "+Constants.LENGTH_UNIT
            lapRecordLabel.text     = Constants.LAP_RECORD_LABEL
            
            if let recordHolderName     = selectedTrack!.trackRecordHolder?.name, let trackRecord = selectedTrack!.trackRecord{
                lapRecordHolder.text    = recordHolderName
                lapRecordTime.text      = trackRecord
            }else{
                lapRecordHolder.text    = Constants.LAP_RECORD_HOLDER_NONE
                lapRecordTime.isHidden  = true
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mainTimerLabel.text = Constants.LAPTIME_NOT_STARTED
        //session.sessionDateAndTime = Date() as NSDate

        driverCollectionView.delegate   = self
        driverCollectionView.dataSource = self
        
        startButton.layer.cornerRadius  = 10
        startButton.layer.masksToBounds = true
        
        lapTableview.delegate           = self
        lapTableview.dataSource         = self
        lapTableview.tableFooterView    = UIView()
        
        let date = Date()
        let formatter = DateFormatter()
        //TODO: - Internationalize this
        formatter.dateFormat = "dd.MM.yyyy"
        let todayString = formatter.string(from: date)
//        self.navigationController?.title = todayString

        //present the track selector view, as there should not be a session without a track
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let trackSelector = storyboard.instantiateViewController(withIdentifier: "TrackSelector") as! TrackSelectorViewController
        self.present(trackSelector, animated: false, completion: nil)
        trackSelector.trackSelectorDelegate = self
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("i prepare for segue")
         if segue.identifier == "SelectDriverSegue" {
            if let vc = segue.destination as? DriverSelectorViewController{
                vc.driverSelectorDelegate = self
            }
        }
    }

    @IBAction func save(_ sender: UIBarButtonItem) {
        //going home
        //needs checks for a lot of stuff:
        // - timer still running? is there somthing to save?
        if mainTimerEnabled {
            print("Timer is still running. End timer before saving.")
        }
        
        let session = Session(context: CoreDataService.context)
        session.sessionDateAndTime  = Date()
        session.onTrack             = selectedTrack
        session.drivers?.addingObjects(from: participatingDrivers)
        session.fastestDriver   = laps[0].driver!
        session.fastestLapTime  = laps[0].lapTime.fromTimeToString()
        session.fastestLapSpeed = "250"
        session.numberOfLaps    = Int16(laps.count)
        print("Trying to save?")
        CoreDataService.saveContext()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - TIMER
    /// Helper function to define whether the timer is safe to start or not
    ///
    /// - Returns: Bool: result of evaluation, String?: title of error message, String? body of error message
    /// - Returns: Strings are nil if evaluation is true
    func isItSafeToStartTimer() -> (Bool,String?,String?) {
        guard selectedTrack != nil else{
            return (false,Constants.NO_TRACK_TITLE,Constants.NO_TRACK)
        }
        guard participatingDrivers.count > 0 else{
            return (false,Constants.NO_DRIVER_TITLE,Constants.NO_DRIVER)
        }
        return (true,nil,nil)
    }
    
    @IBAction func startTimer(_ sender: UIButton) {
        guard isItSafeToStartTimer().0 else{
            let alertController = UIAlertController(title: isItSafeToStartTimer().1, message: isItSafeToStartTimer().2, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: Constants.ALERT_CANCEL, style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
            return
        }
        //Check's done, it's now safe to start the timer
        mainTimerEnabled.toggle()
        if(mainTimerEnabled){
            sender.setTitle(Constants.BUTTON_STOP, for: .normal)
            sender.backgroundColor = .red
            
            //starting all timers
            mainTimerStartTime = Date().timeIntervalSinceReferenceDate
            for (index, _) in participatingDrivers.enumerated(){
                participatingDrivers[index].1.isRunning = true
            }
            mainTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            RunLoop.current.add(mainTimer!, forMode: .common) //to make sure that user interaction with the screen does not interferes with the timer
            
        }else{
            sender.setTitle(Constants.BUTTON_START, for: .normal)
            sender.backgroundColor = UIColor(red: (79.0/255.0), green: (143.0/255.0), blue: (0.0/255.0), alpha: 1)
            //stopping all timers
            mainTimer!.invalidate()
            for (index, _) in participatingDrivers.enumerated(){
                participatingDrivers[index].1.isRunning = false
            }
        }
    }
    
    @objc func updateTimer(){
        mainTimerLabel.text = mainTimerStartTime.fromTimeToString()
        
        //updates timer labels for all the visible driver cells
        for indexPath in self.driverCollectionView!.indexPathsForVisibleItems{
            let cell = self.driverCollectionView!.cellForItem(at: indexPath) as! DriverCollectionViewCell
            cell.updateLabels(lapTime: participatingDrivers[indexPath.row].1.startTime!)
        }
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
        participatingDrivers.append( (driver,RaceDayTimer()) )
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
        cell.timeLabel.text = laps[indexPath.row].lapTime.fromTimeToString() 
        cell.lapNumberLabel.text = "\(laps[indexPath.row].lapNumber)"
        return cell
    }
}

//MARK: - CollectionView
extension TimerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return participatingDrivers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = driverCollectionView.dequeueReusableCell(withReuseIdentifier: DriverCollectionViewCell.reuseIdentifier, for: indexPath) as! DriverCollectionViewCell
        let driver = participatingDrivers[indexPath.row].0
        cell.setup(title: driver.name!, image: UIImage(data: driver.image!)! )
        return cell
    }
    
    #warning("this needs a serious rework")
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = driverCollectionView.dequeueReusableCell(withReuseIdentifier: DriverCollectionViewCell.reuseIdentifier, for: indexPath) as! DriverCollectionViewCell
        //find the lapnumber for the current driver based on occurences in the Laps array
        let lapNumber = laps.filter {$0.driver == participatingDrivers[indexPath.row].0}
        //create a new instance of the Lap struct and add it to the array of Laps
        let newLap = Lap(driver: participatingDrivers[indexPath.row].0, lapNumber: lapNumber.count+1, lapTime: participatingDrivers[indexPath.row].1.startTime!, speed: 0) //add 1 to lapNumber as there is no "lap 0"
        laps.append(newLap)
        //starts a new lap
        participatingDrivers[indexPath.row].1.startTime = Date().timeIntervalSinceReferenceDate
        lapTableview.reloadSections([0], with: .automatic)
        lapTableview.scrollToRow(at: IndexPath(row: laps.count-1, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        #warning("work on this, picture size? 75x75?")
        return CGSize(width: 100, height: 100)
    }
}


//TODO:
//Fix lap cells UI in the UITableView
//fix lap cells DATA in the UITableView
//fix saving
