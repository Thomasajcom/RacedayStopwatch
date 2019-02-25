//
//  TimerViewController.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 04/02/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import UIKit

//TODO: - Rewrite this to a more effiecient, cleaner solution. participatingDrivers and laps is unnecessarily complicated
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
    
    var participatingDrivers    = [(Driver,RaceDayTimer)]()
    var drivers                 = [Driver]()
    var laps                    = [Lap]()
    var fastestLap: Lap?
    
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
    
    fileprivate func isItSafeToSave() -> (Bool,String?,String?){
        guard !mainTimerEnabled else{
            print("mainTimerEnabled cant save!")
            return (false,Constants.TIMER_RUNNING_TITLE,Constants.TIMER_RUNNING_BODY)
        }
        guard fastestLap != nil else{
            print("fastestlap !=nil cant save")
            return (false,Constants.NO_LAPS_TITLE,Constants.NO_LAPS_BODY)
        }
        return (true, "ok", "ok")
    }

    @IBAction func save(_ sender: UIBarButtonItem) {
        //check if saving should be allowed
        guard isItSafeToSave().0 else{
            presentAlertController(title: isItSafeToSave().1!, body: isItSafeToSave().2!, actionButton: (Constants.ALERT_CANCEL,.cancel))
            print("It is not safe to save.")
            return
        }
        let session = Session(context: CoreDataService.context)
        session.sessionDateAndTime  = Date()
        session.onTrack             = selectedTrack
        session.drivers             = NSSet(array: drivers)
        session.fastestDriver       = fastestLap!.driver
        session.fastestLapTime      = fastestLap!.lapTime.laptimeToString()
        session.fastestLapSpeed     = Int16(fastestLap!.speed)
        session.numberOfLaps        = Int16(laps.count)
        CoreDataService.saveContext()
        presentAlertController(title: isItSafeToSave().1!, body: isItSafeToSave().2!, actionButton: (Constants.ALERT_SAVED,.default))
        
    }
    
    // MARK: - TIMER
    /// Helper function to define whether the timer is safe to start or not
    ///
    /// - Returns: Bool: result of evaluation, String?: title of error message, String? body of error message
    /// - Returns: Strings are nil if evaluation is true
    fileprivate func isItSafeToStartTimer() -> (Bool,String?,String?) {
        guard selectedTrack != nil else{
            return (false,Constants.NO_TRACK_TITLE,Constants.NO_TRACK_BODY)
        }
        guard participatingDrivers.count > 0 else{
            return (false,Constants.NO_DRIVER_TITLE,Constants.NO_DRIVER_BODY)
        }
        return (true,nil,nil)
    }
    
    fileprivate func presentAlertController(title: String, body: String, actionButton: (String,UIAlertAction.Style)) {
        let actionString = actionButton.0
        let alertController = UIAlertController(title: title, message: body, preferredStyle: .alert)
        let action = UIAlertAction(title: actionButton.0, style: actionButton.1) {
            (alert: UIAlertAction!) in
            if (actionString == Constants.ALERT_SAVED){
                print("i presentAlertController soin handler TRUE")
                self.navigationController?.popToRootViewController(animated: true)
            }else{
                print("i presentAlertController soin handler FALSE")

            }
            
        }
//        let action = UIAlertAction(title: actionButton, style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    @IBAction func toggleTimer(_ sender: UIButton) {
        guard isItSafeToStartTimer().0 else{
            presentAlertController(title: isItSafeToStartTimer().1!, body: isItSafeToStartTimer().2!, actionButton: (Constants.ALERT_CANCEL,.cancel) )
            return
        }
        //Check's done, it's now safe to start the timer
        mainTimerEnabled.toggle()
        
        if(mainTimerEnabled){
            sender.setTitle(Constants.BUTTON_STOP, for: .normal)
            sender.backgroundColor = .red
            
            //starting all timers
            mainTimerStartTime = Date().timeIntervalSinceReferenceDate
            mainTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            RunLoop.current.add(mainTimer!, forMode: .common) //to make sure that user interaction with the screen does not interferes with the timer
            
        }else{
            sender.setTitle(Constants.BUTTON_START, for: .normal)
            sender.backgroundColor = UIColor(red: (79.0/255.0), green: (143.0/255.0), blue: (0.0/255.0), alpha: 1)
            //stopping all timers
            mainTimer!.invalidate()
        }
        for (index, _) in participatingDrivers.enumerated(){
            participatingDrivers[index].1.isRunning.toggle()
        }
    }
    
    @objc func updateTimer(){
        mainTimerLabel.text = (Date().timeIntervalSinceReferenceDate - mainTimerStartTime).laptimeToString()
        //updates timer labels for all the visible driver cells
        for indexPath in self.driverCollectionView!.indexPathsForVisibleItems{
            let cell = self.driverCollectionView!.cellForItem(at: indexPath) as! DriverCollectionViewCell
            let lapTime = Date().timeIntervalSinceReferenceDate - participatingDrivers[indexPath.row].1.startTime!
            cell.updateLabels(lapTime: lapTime)
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
        drivers.append(driver)
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
        cell.setup(with: laps[indexPath.row])
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
    
    func calculateSpeed(distance: Int, time: Double) -> Int{
        var speed = 0.0
        #warning("this needs to check userdefaults for miles or meters")
        if (true){//check if metric
            let metersBySecond = Double(distance) / time
            speed = metersBySecond * 3.6
        }else if (false){//if not, then imperialc
            
        }
        return Int(speed)
    }
    
    #warning("this needs a serious rework")
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = driverCollectionView.dequeueReusableCell(withReuseIdentifier: DriverCollectionViewCell.reuseIdentifier, for: indexPath) as! DriverCollectionViewCell
        //find the lapnumber for the current driver based on occurences in the Laps array
        let lapNumber = laps.filter {$0.driver == participatingDrivers[indexPath.row].0}
        let lapTime = Date().timeIntervalSinceReferenceDate - participatingDrivers[indexPath.row].1.startTime!
        let lapSpeed = calculateSpeed(distance: Int(selectedTrack!.length), time: lapTime)
        #warning("error with speed")
        print("speed")
        //create a new instance of the Lap struct and add it to the array of Laps
        let newLap = Lap(driver: participatingDrivers[indexPath.row].0, lapNumber: lapNumber.count+1, lapTime: lapTime, speed: lapSpeed) //add 1 to lapNumber as there is no "lap 0"
        laps.append(newLap)
        
        //check if this lap was the fastest lap
        if fastestLap == nil{
            fastestLap = newLap
        }else if newLap.lapTime < fastestLap!.lapTime{
            fastestLap = newLap
        }
        //starts a new lap
        participatingDrivers[indexPath.row].1.startTime = Date().timeIntervalSinceReferenceDate
        
        lapTableview.beginUpdates()
        lapTableview.insertRows(at: [IndexPath(row: laps.count-1, section: 0)], with: .bottom)
        lapTableview.endUpdates()
        lapTableview.scrollToRow(at: IndexPath(row: laps.count-1, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        #warning("work on this, picture size? 75x75?")
        return CGSize(width: 100, height: 100)
    }
}


//TODO:
//fix saving
//drivers array, only add one driver
