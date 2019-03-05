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
    @IBOutlet weak var lapButton: UIButton!
    
    @IBOutlet weak var addDriverButton: UIButton!
    
    var participatingDrivers    = [(Driver,RaceDayTimer)]()
    var timerWithoutDrivers     = false
    var drivers                 = [Driver]()
    var notSelectedDrivers      = [Driver]()
    var laps                    = [Lap]()
    var fastestLap: Lap?
    
    weak var mainTimer: Timer?
    var mainTimerEnabled: Bool      = false
    var mainTimerStartTime: Double  = 0
    var mainTimerStopTime: Double   = 0

    
    var selectedTrack: Track?
    var customTrackLength: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mainTimerLabel.text = Constants.LAPTIME_NOT_STARTED
        //session.sessionDateAndTime = Date() as NSDate

        driverCollectionView.delegate   = self
        driverCollectionView.dataSource = self
        
        startButton.layer.cornerRadius  = 10
        startButton.layer.masksToBounds = true
        startButton.setTitle(Constants.BUTTON_START, for: .normal)
        lapButton.isHidden = true
        
        lapTableview.delegate           = self
        lapTableview.dataSource         = self
        lapTableview.tableFooterView    = UIView()
        
        let date = Date()
        let formatter = DateFormatter()
        //TODO: - Internationalize this
        formatter.dateFormat = "dd.MM.yyyy"
        let todayString = formatter.string(from: date)
        self.title = todayString
        if let track = selectedTrack{
            trackNameLabel.text     = track.name
            if Constants.defaults.bool(forKey: Constants.defaults_metric_key){
                trackLengthLabel.text   = String(track.length.noDecimals)+" "+Constants.LENGTH_UNIT_METERS
            }else{
                trackLengthLabel.text   = String(Double(track.length).fromMetersToMiles().threeDecimals)+" "+Constants.LENGTH_UNIT_MILES
            }
            lapRecordLabel.text     = Constants.LAP_RECORD_LABEL
            
            if let recordHolderName     = track.trackRecordHolder?.name{
                lapRecordHolder.text    = recordHolderName
                lapRecordTime.text      = track.trackRecord.laptimeToString()
            }else{
                lapRecordHolder.text    = Constants.LAP_RECORD_HOLDER_NONE
                lapRecordTime.isHidden  = true
            }
        }else if let length = customTrackLength{
            if Constants.defaults.bool(forKey: Constants.defaults_metric_key){
                trackNameLabel.text         = String(length)+" "+Constants.LENGTH_UNIT_METERS
            }else{
                trackNameLabel.text         = String(length)+" "+Constants.LENGTH_UNIT_MILES
            }
            
            trackLengthLabel.isHidden   = true
            lapRecordLabel.isHidden     = true
            lapRecordHolder.isHidden    = true
            lapRecordTime.isHidden      = true
        }else {
            trackNameLabel.isHidden     = true
            trackLengthLabel.isHidden   = true
            lapRecordLabel.isHidden     = true
            lapRecordHolder.isHidden    = true
            lapRecordTime.isHidden      = true
        }
        if (timerWithoutDrivers){
            addDriverButton.isHidden = true
            lapButton.layer.cornerRadius  = 10
            lapButton.layer.masksToBounds = true
            lapButton.setTitle(Constants.BUTTON_LAP, for: .normal)
            lapButton.isHidden = false
        }else{
            for driver in drivers{
                participatingDrivers.append( (driver,RaceDayTimer()) )
            }
        }
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "SelectDriverSegue" {
            if let vc = segue.destination as? DriverSelectorViewController{
                vc.driverSelectorDelegate = self
                vc.notSelectedDrivers = notSelectedDrivers
                vc.drivers = drivers
            }
        }
    }
    
    fileprivate func isItSafeToSave() -> (Bool,String?,String?){
        print("laps.count: \(laps.count)")
        guard !mainTimerEnabled else{
            return (false,Constants.TIMER_RUNNING_TITLE,Constants.TIMER_RUNNING_BODY)
        }
        guard laps.count > 0  else{
            return (false,Constants.NO_LAPS_TITLE,Constants.NO_LAPS_BODY)
        }
        return (true, Constants.TIMER_SESSION_SAVED_TITLE, Constants.TIMER_SESSION_SAVED_BODY)
    }

    @IBAction func save(_ sender: UIBarButtonItem) {
        //check if saving should be allowed
        guard isItSafeToSave().0 else{
            presentAlertController(title: isItSafeToSave().1!, body: isItSafeToSave().2!, actionButton: (Constants.ALERT_CANCEL,.cancel))
            return
        }
        let session = Session(context: CoreDataService.context)
        session.sessionDateAndTime  = Date()
        if timerWithoutDrivers{
            session.drivers             = nil
            session.fastestDriver       = nil
            session.fastestLapTime      = fastestLap!.lapTime
            session.fastestLapSpeed     = Int16(fastestLap!.speed)
            session.numberOfLaps        = Int16(laps.count)
            session.totalSessionTime    = mainTimerStopTime - mainTimerStartTime
            if let track = selectedTrack{
                session.onTrack             = track
            }else {
                session.onTrack             = nil
            }
        }else {
            session.drivers             = NSSet(array: drivers)
            session.fastestDriver       = fastestLap!.driver
            session.fastestLapTime      = fastestLap!.lapTime
            session.fastestLapSpeed     = Int16(fastestLap!.speed)
            session.numberOfLaps        = Int16(laps.count)
            session.totalSessionTime    = mainTimerStopTime - mainTimerStartTime
            session.onTrack             = selectedTrack
            if let track = selectedTrack {
                if fastestLap!.lapTime < track.trackRecord || track.trackRecord == 0{
                    session.onTrack?.trackRecord = session.fastestLapTime
                    session.onTrack?.trackRecordHolder = session.fastestDriver
                }
            }
        }
        
        CoreDataService.saveContext()
        presentAlertController(title: isItSafeToSave().1!, body: isItSafeToSave().2!, actionButton: (Constants.ALERT_SAVED,.default))
    }
    
    fileprivate func presentAlertController(title: String, body: String, actionButton: (String,UIAlertAction.Style)) {
        let actionString = actionButton.0
        let alertController = UIAlertController(title: title, message: body, preferredStyle: .alert)
        let action = UIAlertAction(title: actionButton.0, style: actionButton.1) {
            (alert: UIAlertAction!) in
            if (actionString == Constants.ALERT_SAVED){
                self.navigationController?.popToRootViewController(animated: true)
            }else{
            }
            
        }
        alertController.addAction(action)
        present(alertController, animated: true)
    }

    @IBAction func lap(_ sender: UIButton) {
        
        let lapNumber = laps.count+1
        let lapTime = Date().timeIntervalSinceReferenceDate - mainTimerStartTime//participatingDrivers[indexPath.row].1.startTime!
        var lapSpeed = 0
        if selectedTrack != nil{
            lapSpeed = calculateSpeed(distance: Int(selectedTrack!.length), time: lapTime)
        }else if customTrackLength != nil{
            lapSpeed = calculateSpeed(distance: customTrackLength!, time: lapTime)
        }
        //create a new instance of the Lap struct and add it to the array of Laps
        let newLap = Lap(driver: nil, lapNumber: lapNumber, lapTime: lapTime, speed: lapSpeed) //add 1 to lapNumber as there is no "lap 0"
        mainTimerStartTime = Date().timeIntervalSinceReferenceDate
        laps.append(newLap)
        //check if this lap was the fastest lap
        if fastestLap == nil{
            fastestLap = newLap
        }else if newLap.lapTime < fastestLap!.lapTime{
            fastestLap = newLap
        }
        
        lapTableview.beginUpdates()
        lapTableview.insertRows(at: [IndexPath(row: laps.count-1, section: 0)], with: .bottom)
        lapTableview.endUpdates()
        lapTableview.scrollToRow(at: IndexPath(row: laps.count-1, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
    }
    
    @IBAction func toggleTimer(_ sender: UIButton) {
        mainTimerEnabled.toggle()
        if(mainTimerEnabled){
            sender.setTitle(Constants.BUTTON_STOP, for: .normal)
            sender.backgroundColor      = .red
            addDriverButton.isEnabled   = false
            
            //starting timer
            mainTimerStartTime = Date().timeIntervalSinceReferenceDate
            mainTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            RunLoop.current.add(mainTimer!, forMode: .common) //to make sure that user interaction with the screen does not interferes with the timer
        }else{
            sender.setTitle(Constants.BUTTON_START, for: .normal)
            sender.backgroundColor = UIColor(red: (79.0/255.0), green: (143.0/255.0), blue: (0.0/255.0), alpha: 1)
            //stopping timer
            mainTimerStopTime = Date().timeIntervalSinceReferenceDate
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
        let metersBySecond = Double(distance) / time
        let speed = metersBySecond * 3.6
        return Int(speed.rounded(.down))
    }
    
    #warning("this needs a serious rework")
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if mainTimerEnabled {
            //find the lapnumber for the current driver based on occurences in the Laps array
            let lapNumber = laps.filter {$0.driver == participatingDrivers[indexPath.row].0}
            let lapTime = Date().timeIntervalSinceReferenceDate - participatingDrivers[indexPath.row].1.startTime!
            let lapSpeed = calculateSpeed(distance: Int(selectedTrack!.length), time: lapTime)
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
        }else {
            presentAlertController(title: Constants.TIMER_NOT_RUNNING_TITLE, body: Constants.TIMER_NOT_RUNNING_BODY, actionButton: (Constants.ALERT_CANCEL,.cancel))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
