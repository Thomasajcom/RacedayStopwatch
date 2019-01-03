//
//  StopwatchTableViewController.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 09/11/2018.
//  Copyright © 2018 Appbryggeriet. All rights reserved.
//

import UIKit

class StopwatchTableViewController: UITableViewController {
    
    var participants: [Participant] = []
    var laps: [String] = []
    var lastDriver: Int = 0
    var selectedTrack: Track? = nil
    var selectedDriver: Driver? = nil
    var numberOfDrivers = 0
    
    weak var timer: Timer?
    var timerEnabled: Bool = false
    var startTime: Double = 0
    var time: Double = 0
    var minutes: UInt8 = 00
    var seconds: UInt8 = 00
    var miliseconds: UInt64 = 000


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //the default participant is the default timer with no selected driver
        participants.append(Participant(name: "Default", lapTime: [""]))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return numberOfDrivers
        case 3:
            return laps.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: TrackTableViewCell.reuseIdentifier, for: indexPath) as! TrackTableViewCell
            //flips the cell content to fit with the flipped tableview
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)

            if let selectedTrack = selectedTrack{
                cell.tracknameLabel.text = selectedTrack.name
                cell.trackLengthLabel.text = "\(selectedTrack.length) meters"
            }else{
                cell.tracknameLabel.text = "No Track Selected"
                cell.trackLengthLabel.text = ""
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: StopwatchTableViewCell.reuseIdentifier, for: indexPath) as! StopwatchTableViewCell
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)

            cell.stopwatchDelegate = self
            cell.startButton.layer.cornerRadius = 10
            cell.startButton.layer.masksToBounds = true
            cell.lapButton.layer.cornerRadius = 10
            cell.lapButton.layer.masksToBounds = true
            
            if(timerEnabled){
                cell.startButton.setTitle("STOP", for: .normal)
                cell.startButton.backgroundColor = .red
            }else if(!timerEnabled){
                cell.startButton.setTitle("Start", for: .normal)
                cell.startButton.backgroundColor = UIColor(red: (79.0/255.0), green: (143.0/255.0), blue: (0.0/255.0), alpha: 1)
            }
            
            cell.minutesLabel.text = String(format: "%02d", minutes)
            cell.secondsLabel.text = String(format: "%02d", seconds)
            cell.milisecondsLabel.text = String(format: "%03d", miliseconds)//change to numberformatter
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: DriverTableViewCell.reuseIdentifier, for: indexPath) as! DriverTableViewCell
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)

            if let selectedDriver = selectedDriver{
                cell.nameLabel.text = selectedDriver.name
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: LapTableViewCell.reuseIdentifier, for: indexPath) as! LapTableViewCell
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)

            
            cell.lapLabel.text = "Lap \(participants[lastDriver].lapTime.count-1) - \(participants[lastDriver].name)"
            
            cell.timeLabel.text = String(format: "%02d : %02d : %03d", arguments: [minutes, seconds, miliseconds])
            cell.speedLabel.text = "25 km/t"
            return cell
        default:
            return UITableViewCell.init(style: .default, reuseIdentifier: "")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 2){
            let cell = tableView.cellForRow(at: indexPath) as? DriverTableViewCell
            lapTimer(by: cell!.nameLabel.text!)
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SelectTrackSegue" {
            if let vc = segue.destination as? TrackSelectorViewController{
                vc.trackSelectorDelegate = self
                vc.getTracks = true
            }
        }else if segue.identifier == "SelectDriverSegue"{
            if let vc = segue.destination as? TrackSelectorViewController{
                vc.trackSelectorDelegate = self
                vc.getTracks = false
            }
        }
    }

    @IBAction func save(_ sender: Any) {
        print("Going to save Session to Core Data!")
    }
    
    func startTimer(){
        //laps.append("\(laps.count+1)")
//        tableView.beginUpdates()
//        tableView.insertRows(at: [IndexPath(row: 0, section: 3)], with: .fade)
//        tableView.endUpdates()
        startTime = Date().timeIntervalSinceReferenceDate
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        timerEnabled = true
    }
    func stopTimer(){
        timer!.invalidate()
        timerEnabled = false
    }
    func lapTimer(by driver: String){
        if let index = participants.index(where: {$0.name == driver}){
            lastDriver = index
            participants[index].lapTime.append("")//empty string
        }else{
            participants.append(Participant(name: (driver), lapTime: [""]))
            lastDriver = participants.endIndex-1
        }
        laps.append("\(laps.count+1)")
        print("LAPPED TIMER")
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: 0, section: 3)], with: .fade)
        tableView.endUpdates()
    }
    
    //rework this method
    @objc func update(){
        print("timer i gang")
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
        
        tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
    }
}

//swap delegate protocol here, the cell should call controllers methods
extension StopwatchTableViewController: StopwatchTableViewCellDelegate{
    func startedTimer() {
        print("Started TIMER")
        startTimer()
    }
    func stoppedTimer() {
        print("stopped TIMER")
        stopTimer()
    }
    func newLap(){
        lapTimer(by: "Default")
    }
}

extension StopwatchTableViewController: TrackSelectorViewControllerDelegate{
    func selected(item: Any, isTrack: Bool) {
        if(isTrack){
            let track = item as? Track
            selectedTrack = track
            tableView.beginUpdates()
            tableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .left)
            tableView.insertRows(at: [IndexPath(row:0, section:0)], with: .right)
            tableView.endUpdates()
        }else{
            let driver = item as? Driver
            selectedDriver = driver
            numberOfDrivers += 1
            #warning("Don't bang stuff!")
            //participants.append(Participant(name: (driver?.name)!, lapTime: [""]))
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row:numberOfDrivers-1, section:2)], with: .right)
            tableView.endUpdates()
        }
        
        
    }
    
    
}

//Det neste som må gjøres: lag et array som holder styr på alle rader som legges til slik at celler ikke reuses??
//sjekk ut PREPAREFORREUSE

struct Participant {
    var name: String
    var lapTime: [String]
}
