//
//  TrackSelectorViewController.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 13/11/2018.
//  Copyright © 2018 Appbryggeriet. All rights reserved.
//

import UIKit
import CoreData

protocol TrackSelectorViewControllerDelegate {
    func selected(item: Any, isTrack: Bool)
}

class TrackSelectorViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var popupView: UIView!
    var trackSelectorDelegate: TrackSelectorViewControllerDelegate!
    @IBOutlet weak var trackPicker: UIPickerView!
    var tracks: [Track]? = []
    var drivers: [Driver]? = []
    let trackFetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
    let driverFetchRequest: NSFetchRequest<Driver> = Driver.fetchRequest()
    var getTracks: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
        
        trackPicker.delegate = self
        trackPicker.dataSource = self
        
        if(getTracks){
            titleLabel.text = "Select Track"
            do {
                tracks = try CoreDataService.context.fetch(trackFetchRequest)
            } catch let error as NSError {
                print("\(error)")
            }
        }else{
            titleLabel.text = "Select Driver"
            do {
                drivers = try CoreDataService.context.fetch(driverFetchRequest)
            } catch let error as NSError {
                print("\(error)")
            }
        }
        
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        if(getTracks){
            trackSelectorDelegate.selected(item: tracks![trackPicker.selectedRow(inComponent: 0)], isTrack: true)
        }else{
            trackSelectorDelegate.selected(item: drivers![trackPicker.selectedRow(inComponent: 0)], isTrack: false)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension TrackSelectorViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let tracks = tracks else {return 0}
        guard let drivers = drivers else {return 0}
        return (getTracks ? tracks.count : drivers.count)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if getTracks{
            if let tracks = tracks{
                return "\(tracks[row].name) - \(tracks[row].length)"
            }else{ return "Error getting track name" }
        }else{
            if let drivers = drivers{
                return "\(drivers[row].name)"
            }else{ return "Error getting driver name" }
        }
    }
}
