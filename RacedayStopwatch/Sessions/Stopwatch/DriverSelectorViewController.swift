//
//  DriverSelectorViewController.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 13/11/2018.
//  Copyright © 2018 Appbryggeriet. All rights reserved.
//

import UIKit
import CoreData

protocol DriverSelectorViewControllerDelegate {
    func selected(driver: Driver)
}

class DriverSelectorViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var popupView: UIView!
    var driverSelectorDelegate: DriverSelectorViewControllerDelegate!
    @IBOutlet weak var driverPicker: UIPickerView!
    var drivers: [Driver]?
    let driverFetchRequest: NSFetchRequest<Driver> = Driver.fetchRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
        
        driverPicker.delegate = self
        driverPicker.dataSource = self
        
        // TODO: - Internationalize this
        titleLabel.text = "Select Driver"
        do {
            drivers = try CoreDataService.context.fetch(driverFetchRequest)
        } catch let error as NSError {
            print("\(error)")
        }
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        print("Selected driver:\(driverPicker.selectedRow(inComponent: 0))")
        print("driver array: \(drivers!.count)")
        print("driver array: \(drivers![driverPicker.selectedRow(inComponent: 0)])")
        driverSelectorDelegate.selected(driver: drivers![driverPicker.selectedRow(inComponent: 0)])
        dismiss(animated: true, completion: nil)
    }
}

extension DriverSelectorViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let drivers = drivers else {return 0}
        return drivers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let drivers = drivers{
            return "\(drivers[row].name) - \(drivers[row].number)"
        }else{ return "Error getting Driver name" }
    }
}
