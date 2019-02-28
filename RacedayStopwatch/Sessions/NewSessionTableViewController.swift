//
//  NewSessionTableViewController.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 28/02/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import UIKit
import CoreData

class NewSessionTableViewController: UITableViewController {
    
    var tracks: [Track]?
    let trackFetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
    @IBOutlet weak var trackPicker: UIPickerView!
    @IBOutlet weak var noTrackLabel: UILabel!
    @IBOutlet weak var noTrackSwitch: UISwitch!
    @IBOutlet weak var noTrackLength: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackPicker.delegate = self
        trackPicker.dataSource = self
        noTrackLabel.text = Constants.SESSION_WITHOUT_TRACK
        noTrackLength.placeholder = Constants.SESSION_CUSTOM_LENGTH

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        do {
            tracks = try CoreDataService.context.fetch(trackFetchRequest)
        } catch let error as NSError {
            print("\(error)")
        }
    }

    @IBAction func noTrackSwitchChanged(_ sender: UISwitch) {
        noTrackLength.isEnabled.toggle()
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

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
        if (segue.identifier == "timerSegue"){
            let newTimer = segue.destination as! TimerViewController
            newTimer.hidesBottomBarWhenPushed = true
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            
            //set track and drivers on the new vc here
            if noTrackSwitch.isOn{
                newTimer.selectedTrack = nil
                if let length = noTrackLength.text, noTrackLength.text != ""{
                    newTimer.customLength = Int(length)
                }
            }else{
                newTimer.selectedTrack = tracks![trackPicker.selectedRow(inComponent: 0)]
            }
        }
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
        return tracks[row].name
    }
}
