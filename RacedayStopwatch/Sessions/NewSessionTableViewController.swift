//
//  NewSessionTableViewController.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 28/02/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import UIKit
import CoreData

//TODO: - Make the driversCollectionView it's own class, so it can be reused in the timerview, add driver in timerview etc
class NewSessionTableViewController: UITableViewController {
    
    var tracks: [Track]?
    let trackFetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
    @IBOutlet weak var trackPicker: UIPickerView!
    @IBOutlet weak var noTrackLabel: UILabel!
    @IBOutlet weak var noTrackSwitch: UISwitch!
    @IBOutlet weak var noTrackLength: UITextField!
    
    var drivers: [Driver]?
    var selectedDrivers = [Driver]()
    var notSelectedDrivers = [Driver]()
    let driverFetchRequest: NSFetchRequest<Driver> = Driver.fetchRequest()
    @IBOutlet weak var driversCollectionView: UICollectionView!
    @IBOutlet weak var noDriversLabel: UILabel!
    @IBOutlet weak var noDriversSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 50.0;
        trackPicker.delegate        = self
        trackPicker.dataSource      = self
        noTrackLabel.text           = Constants.SESSION_WITHOUT_TRACK
        noTrackLength.placeholder   = Constants.SESSION_CUSTOM_LENGTH
        addDoneButton()
        
        driversCollectionView.delegate      = self
        driversCollectionView.dataSource    = self
        driversCollectionView.allowsMultipleSelection = true
        noDriversLabel.text                 = Constants.SESSION_WITHOUT_DRIVER
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        do {
            tracks = try CoreDataService.context.fetch(trackFetchRequest)
        } catch let error as NSError {
            print("\(error)")
        }
        do {
            drivers = try CoreDataService.context.fetch(driverFetchRequest)
            #warning("check what happens without drivers")
        } catch let error as NSError {
            print("\(error)")
        }
    }
    
    @IBAction func noTrackSwitchChanged(_ sender: UISwitch) {
        noTrackLength.isEnabled.toggle()
    }
    @IBAction func noDriversSwitchChanged(_ sender: UISwitch) {
        driversCollectionView.allowsSelection.toggle()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 3
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return Constants.TRACK_SELECT_TITLE
        case 1:
            return Constants.SESSION_DRIVER_SELECT_TITLE
        default:
            return ""
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "timerSegue"){
            let newTimer = segue.destination as! TimerViewController
            newTimer.hidesBottomBarWhenPushed = true
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            
            //set track on the timer vc
            if let track = tracks, track.count > 0 && !noTrackSwitch.isOn{
                newTimer.selectedTrack = track[trackPicker.selectedRow(inComponent: 0)]
            }else if noTrackSwitch.isOn{
                if let length = noTrackLength.text, noTrackLength.text != ""{
                    newTimer.customTrackLength = Int(length)
                }
            }else{
                let alertController = UIAlertController(title: Constants.SESSION_TRACK_ERROR_TITLE, message: Constants.SESSION_TRACK_ERROR_BODY, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(action)
                present(alertController, animated: true)
            }
            
            //set drivers on the timer vc
            for indexPath in (driversCollectionView.indexPathsForSelectedItems)!{
                selectedDrivers.append(drivers![indexPath.item])
            }
            for i in 0..<driversCollectionView.numberOfItems(inSection: 0){
                if (!(driversCollectionView.indexPathsForSelectedItems?.contains(IndexPath(item: i, section: 0)))!){
                    notSelectedDrivers.append(drivers![i])
                }
            }
            if noDriversSwitch.isOn{
                newTimer.timerWithoutDrivers = true
            }else if selectedDrivers.count > 0{
                newTimer.drivers = selectedDrivers
                newTimer.notSelectedDrivers = notSelectedDrivers
            }else{
                let alertController = UIAlertController(title: Constants.SESSION_DRIVER_ERROR_TITLE, message: Constants.SESSION_DRIVER_ERROR_BODY, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(action)
                present(alertController, animated: true)
            }
        }
    }
    
    //refactor to an extension as it's being used multiple places
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexSpace, doneBarButton]
        noTrackLength.inputAccessoryView = keyboardToolbar
    }
}

extension NewSessionTableViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let tracks = tracks, tracks.count > 0 else {return 1}
        return tracks.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let tracks = tracks, tracks.count > 0 else {return "No tracks found."}
        return tracks[row].name //+ " " + String(tracks[row].length) + Constants.LENGTH_UNIT
    }
}

//MARK: - CollectionView
extension NewSessionTableViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard drivers != nil else {
            return 0
        }
        return drivers!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = driversCollectionView.dequeueReusableCell(withReuseIdentifier: DriverCollectionViewCell.reuseIdentifier, for: indexPath) as! DriverCollectionViewCell
        let driver = drivers![indexPath.row]
        cell.setup(title: driver.name!, image: UIImage(data: driver.image!)!)
        cell.timerLabel.text = Constants.DRIVER_IS_SELECTED
        if cell.isSelected{
            cell.timerLabel.isHidden = false
        }else{
            cell.timerLabel.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DriverCollectionViewCell
        cell.timerLabel.isHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DriverCollectionViewCell
        cell.timerLabel.isHidden = true
        cell.contentView.backgroundColor = .red
        UIView.animate(withDuration: 0.3) {
            cell.contentView.backgroundColor = .white
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
