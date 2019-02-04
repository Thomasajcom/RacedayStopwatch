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
    func selected(track: Track)
}

class TrackSelectorViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var popupView: UIView!
    var trackSelectorDelegate: TrackSelectorViewControllerDelegate!
    @IBOutlet weak var trackPicker: UIPickerView!
    var tracks: [Track]?
    let trackFetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
        
        trackPicker.delegate = self
        trackPicker.dataSource = self
        
        titleLabel.text = "Select Track"
        do {
            tracks = try CoreDataService.context.fetch(trackFetchRequest)
        } catch let error as NSError {
            print("\(error)")
        }
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        trackSelectorDelegate.selected(track: tracks![trackPicker.selectedRow(inComponent: 0)])
        dismiss(animated: true, completion: nil)
    }
}

extension TrackSelectorViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let tracks = tracks else {return 0}
        return tracks.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let tracks = tracks{
            return "\(tracks[row].name) - \(tracks[row].length)"
        }else{ return "Error getting track name" }
    }
}
