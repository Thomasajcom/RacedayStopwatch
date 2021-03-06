//
//  NewSessionTableViewController.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 28/02/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import UIKit
import CoreData


//TODO: - Make the driversCollectionView its own class, so it can be reused in the timerview, add driver in timerview etc
class NewSessionTableViewController: UITableViewController {
    
    var tracks: [Track]?
    let trackFetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
    @IBOutlet weak var trackPicker: UIPickerView!
    @IBOutlet weak var noTrackLabel: UILabel!
    @IBOutlet weak var noTrackSwitch: UISwitch!
    @IBOutlet weak var noTrackLength: UITextField!
    @IBOutlet weak var trackSelectorCell: UITableViewCell!
    @IBOutlet weak var driverSelectorCell: UITableViewCell!
    @IBOutlet weak var noDriverCell: UITableViewCell!
    @IBOutlet weak var noTrackCell: UITableViewCell!
    @IBOutlet weak var customLengthCell: UITableViewCell!
    @IBOutlet weak var doneCell: UITableViewCell!
    @IBOutlet weak var doneButton: UIButton!
    
    var drivers: [Driver]?
    var selectedDrivers = [Driver]()
    var notSelectedDrivers = [Driver]()
    let driverFetchRequest: NSFetchRequest<Driver> = Driver.fetchRequest()
    @IBOutlet weak var driversCollectionView: UICollectionView!
    @IBOutlet weak var noDriversLabel: UILabel!
    @IBOutlet weak var noDriversSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.NEW_SESSION_TITLE
        self.tableView.rowHeight            = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight   = 50.0;
        trackPicker.delegate                = self
        trackPicker.dataSource              = self
        noTrackLabel.text                   = Constants.SESSION_WITHOUT_TRACK
        addDoneButton()
        
        driversCollectionView.delegate      = self
        driversCollectionView.dataSource    = self
        driversCollectionView.allowsMultipleSelection = true
        noDriversLabel.text                 = Constants.SESSION_WITHOUT_DRIVER
        doneButton.setTitle(Constants.NEW_SESSION_START, for: .normal)

        do {
            tracks = try CoreDataService.context.fetch(trackFetchRequest)
            drivers = try CoreDataService.context.fetch(driverFetchRequest)
        } catch let error as NSError {
            print("\(error)")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupTheme()
    }
    
    func setupTheme(){
        navigationController?.navigationBar.barTintColor    = Theme.activeTheme.barColor
        navigationController?.navigationBar.tintColor       = Theme.activeTheme.tintColor
        tabBarController?.tabBar.barTintColor               = Theme.activeTheme.barColor
        tabBarController?.tabBar.tintColor                  = Theme.activeTheme.tintColor
        
        tableView.separatorColor                = Theme.activeTheme.tintColor
        tableView.backgroundColor               = Theme.activeTheme.backgroundColor
        trackPicker.backgroundColor             = Theme.activeTheme.foregroundColor
        trackPicker.tintColor                   = Theme.activeTheme.tintColor
        noDriversSwitch.tintColor               = Theme.activeTheme.tintColor
        noDriversSwitch.onTintColor             = Theme.activeTheme.confirmColor
        noDriversSwitch.thumbTintColor          = Theme.activeTheme.mainFontColor
        noTrackSwitch.tintColor                 = Theme.activeTheme.tintColor
        noTrackSwitch.onTintColor               = Theme.activeTheme.confirmColor
        noTrackSwitch.thumbTintColor            = Theme.activeTheme.mainFontColor
        
        trackSelectorCell.backgroundColor       = Theme.activeTheme.foregroundColor
        driverSelectorCell.backgroundColor      = Theme.activeTheme.foregroundColor
        doneCell.backgroundColor                = Theme.activeTheme.foregroundColor
        doneButton.setTitleColor(Theme.activeTheme.tintColor, for: .normal)
        driversCollectionView.backgroundColor   = Theme.activeTheme.foregroundColor
        noDriverCell.backgroundColor            = Theme.activeTheme.foregroundColor
        noTrackCell.backgroundColor             = Theme.activeTheme.foregroundColor
        customLengthCell.backgroundColor        = Theme.activeTheme.foregroundColor
        noDriversLabel.textColor = Theme.activeTheme.mainFontColor
        noTrackLabel.textColor = Theme.activeTheme.mainFontColor
        noTrackLength.attributedPlaceholder = NSAttributedString(string: Constants.SESSION_CUSTOM_LENGTH, attributes: [NSAttributedString.Key.foregroundColor:Theme.activeTheme.tintColor])
        
    }
    
    @IBAction func noTrackSwitchChanged(_ sender: UISwitch) {
        noTrackLength.isEnabled.toggle()
        trackPicker.isHidden.toggle()
        if trackPicker.isHidden{
            doneButton.setTitle(Constants.NEW_SESSION_START_NO_TRACK, for: .normal)
        }else{
            doneButton.setTitle(Constants.NEW_SESSION_START, for: .normal)
        }
    }
    @IBAction func noDriversSwitchChanged(_ sender: UISwitch) {
        //driversCollectionView.allowsSelection.toggle()
        driversCollectionView.isHidden.toggle()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 3
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
        case 2:
            return nil
        case 3:
            return Constants.NEW_SESSION_TIMER_ONLY_TITLE
        default:
            return ""
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "timerSegue"){
            let newTimer                                = segue.destination as! TimerViewController
            newTimer.hidesBottomBarWhenPushed           = true
            newTimer.navigationItem.hidesBackButton     = true
            let exitButton = UIBarButtonItem(title: Constants.TIMER_EXIT, style: .plain, target: self, action: #selector(exitToRoot))
            newTimer.navigationItem.leftBarButtonItem   = exitButton
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
    @objc func exitToRoot(){
        let alertController = UIAlertController(title: Constants.TIMER_EXIT, message: Constants.TIMER_EXIT_MESSAGE, preferredStyle: .alert)
        let cancelAction    = UIAlertAction(title: Constants.ALERT_CANCEL, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let okAction = UIAlertAction(title: Constants.ALERT_OK, style: .destructive) { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    //refactor to an extension as it's being used multiple places
    func addDoneButton() {
        let keyboardToolbar     = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexSpace           = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton       = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items   = [flexSpace, doneBarButton]
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
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        guard let tracks = tracks, tracks.count > 0 else {
            return NSAttributedString(string: Constants.NEW_SESSION_NO_TRACK, attributes: [NSAttributedString.Key.foregroundColor : Theme.activeTheme.mainFontColor])
        }
        return NSAttributedString(string: tracks[row].name!, attributes: [NSAttributedString.Key.foregroundColor : Theme.activeTheme.mainFontColor])
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
        let cell            = driversCollectionView.dequeueReusableCell(withReuseIdentifier: DriverCollectionViewCell.reuseIdentifier, for: indexPath) as! DriverCollectionViewCell
        let driver          = drivers![indexPath.row]
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
        let cell                            = collectionView.cellForItem(at: indexPath) as! DriverCollectionViewCell
        cell.timerLabel.isHidden            = true
        cell.contentView.backgroundColor    = Theme.activeTheme.deleteColor
        UIView.animate(withDuration: 0.3) {
            cell.contentView.backgroundColor = Theme.activeTheme.foregroundColor
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

