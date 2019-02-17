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
    
    
    @IBOutlet weak var mainTimerMinutesLabel: UILabel!
    @IBOutlet weak var mainTimerSecondsLabel: UILabel!
    @IBOutlet weak var mainTimerMilisecondsLabel: UILabel!
    
    @IBOutlet weak var lapTableview: UITableView!
    @IBOutlet weak var driverCollectionView: UICollectionView!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var addDriverButton: UIButton!
    
    var participatingDrivers =  [(Driver,RaceDayTimer)]()
    var laps = [Lap]()
    
    weak var mainTimer: Timer?
    var mainTimerEnabled: Bool = false
    var mainTimerStartTime: Double = 0
    var time: Double = 0
    var minutes: UInt8 = 00
    var seconds: UInt8 = 00
    var miliseconds: UInt64 = 000
    
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
        //session.sessionDateAndTime = Date() as NSDate

        driverCollectionView.delegate = self
        driverCollectionView.dataSource = self
        
        startButton.layer.cornerRadius = 10
        startButton.layer.masksToBounds = true
        
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
        print("i prepare for segue")
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
        if mainTimerEnabled {
            print("Timer is still running. End timer before saving.")
        }
        
        let session = Session(context: CoreDataService.context)
        session.sessionDateAndTime = Date()
        session.onTrack = selectedTrack
        session.drivers?.addingObjects(from: participatingDrivers)
        session.fastestDriver   = laps[0].driver!
        session.fastestLapTime  = laps[0].lapTime
        session.fastestLapSpeed = "250"
        session.numberOfLaps    = Int16(laps.count)
        print("Trying to save?")
        CoreDataService.saveContext()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - TIMER
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
            
            mainTimerStartTime = Date().timeIntervalSinceReferenceDate
            for (index, _) in participatingDrivers.enumerated(){
                participatingDrivers[index].1.isRunning = true
            }
//            TIMER ISNT WORKING
//            for var participants in participatingDrivers{
//                participants.1.isRunning = true
//                print("i for participants og setter timer laptimes: \(participants)")
//            }
            mainTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            RunLoop.current.add(mainTimer!, forMode: .common) //to make sure that user interaction with the screen does not interferes with the timer
            
        }else{
            sender.setTitle(Constants.BUTTON_START, for: .normal)
            sender.backgroundColor = UIColor(red: (79.0/255.0), green: (143.0/255.0), blue: (0.0/255.0), alpha: 1)
            mainTimer!.invalidate()
        }
    }
    
    @objc func updateTimer(){
        //apparently this needs to be redone
        // Calculate total time since timer started in seconds
        time = Date().timeIntervalSinceReferenceDate - mainTimerStartTime
        calculateTime(from: time)
        updateTimerLabels()
        
        for indexPath in self.driverCollectionView!.indexPathsForVisibleItems{
            let time = Date().timeIntervalSinceReferenceDate - participatingDrivers[indexPath.row].1.startTime!
//            participatingDrivers[indexPath.row].1.isRunning = true
            calculateTime(from: time)
            let cell = self.driverCollectionView!.cellForItem(at: indexPath) as! DriverCollectionViewCell
            cell.updateLabels(minutes: String(format: "%02d", minutes), seconds: String(format: "%02d", seconds), miliseconds: String(format: "%03d", miliseconds))
        }
    }
    
    func calculateTime(from time: Double){
        var newTime = time
        // Calculate minutes
        minutes = UInt8(newTime / 60.0)
        newTime -= (TimeInterval(minutes) * 60)
        // Calculate seconds
        seconds = UInt8(newTime)
        newTime -= TimeInterval(seconds)
        // Calculate milliseconds
        miliseconds = UInt64(newTime * 1000)
    }
    
    //temp to calculate string from date
    func calcTimeToString(from time: Double) -> String{
        var newTime = Date().timeIntervalSinceReferenceDate - time
        var minutes = UInt8(newTime / 60.0)
        newTime -= (TimeInterval(minutes) * 60)
        var seconds = UInt8(newTime)
         newTime -= TimeInterval(seconds)
        var miliseconds = UInt64(newTime * 1000)
        return "\(minutes):\(seconds):\(miliseconds)"
    }
    
    func updateTimerLabels(){
        mainTimerMinutesLabel.text = String(format: "%02d", minutes)
        mainTimerSecondsLabel.text = String(format: "%02d", seconds)
        mainTimerMilisecondsLabel.text = String(format: "%03d", miliseconds)//change to numberformatter
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
        cell.timeLabel.text = laps[indexPath.row].lapTime
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
        let lapTimeString = calcTimeToString(from: participatingDrivers[indexPath.row].1.startTime!)
        let newLap = Lap(driver: participatingDrivers[indexPath.row].0, lapNumber: lapNumber.count+1, lapTime: lapTimeString, speed: 0) //add 1 to lapNumber as there is no "lap 0"
        
        laps.append(newLap)
        participatingDrivers[indexPath.row].1.startTime = Date().timeIntervalSinceReferenceDate
        lapTableview.reloadSections([0], with: .automatic)
        lapTableview.scrollToRow(at: IndexPath(row: laps.count-1, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}





//TODO: - the popup showing selectable drivers must be added to an array where they can be removed when selected
// - Check with user if timer should start without track or drivers
// remove ability to flick to previous screen while timer is running
// increase driver window?
// format all timer text correctly
