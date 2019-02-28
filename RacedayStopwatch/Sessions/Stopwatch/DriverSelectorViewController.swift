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
    var drivers = [Driver]()
    var notSelectedDrivers = [Driver]()
    let driverFetchRequest: NSFetchRequest<Driver> = Driver.fetchRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius    = Constants.cornerRadius
        popupView.layer.masksToBounds   = true
        
        driverPicker.delegate   = self
        driverPicker.dataSource = self
        titleLabel.text = Constants.TIMER_SELECT_DRIVER
//        do {
//            drivers = try CoreDataService.context.fetch(driverFetchRequest)
//        } catch let error as NSError {
//            print("\(error)")
//        }
    }
    
    //add ADD button
    @IBAction func dismiss(_ sender: UIButton) {
        if notSelectedDrivers.count > 0{
            driverSelectorDelegate.selected(driver: notSelectedDrivers[driverPicker.selectedRow(inComponent: 0)])
        }
        dismiss(animated: true, completion: nil)
    }
}

extension DriverSelectorViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return notSelectedDrivers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return notSelectedDrivers[row].name! + " #" + notSelectedDrivers[row].number!
    }
}
