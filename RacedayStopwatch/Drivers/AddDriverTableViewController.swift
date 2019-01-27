//
//  AddDriverTableViewController.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 06/01/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import UIKit

class AddDriverTableViewController: UITableViewController {
    
    
    @IBOutlet weak var driverName: UITextField!
    @IBOutlet weak var driverNumber: UITextField!
    @IBOutlet weak var helmetPickerView: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    
    var helmets: [UIImage] = [
        UIImage(named: "helmet_red")!,
        UIImage(named: "helmet_blue")!,
        UIImage(named: "helmet_yellow")!,
        UIImage(named: "helmet_purple")!,
        UIImage(named: "helmet_green")!,
        ]
    var driver: Driver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        driverNumber.keyboardType = .numberPad
        if let driver = driver {
            driverName.text = driver.name
            driverNumber.text = driver.number
            
            saveButton.setTitle("Save", for: .normal)
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    @IBAction func save(_ sender: Any) {
        if let driver = driver{
            print("trying to save an edited driver")
            driver.name = driverName.text!
            driver.number = driverNumber.text!
            driver.image = helmets[helmetPickerView.selectedRow(inComponent: 0)].pngData()! as NSData
            CoreDataService.saveContext()
            dismiss(animated: true, completion: nil)
        }else {
            let driver = Driver(context: CoreDataService.context)
            if let newDriverName = driverName.text, !newDriverName.isEmpty, newDriverName != ""{
                driver.name = newDriverName
            }else {
                driverName.attributedPlaceholder = NSAttributedString(string: "ENTER NAME",attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            }
            if let newDriverNumber = driverNumber.text, !newDriverNumber.isEmpty, newDriverNumber != ""{
                driver.number = newDriverNumber
            }else{
                driverNumber.attributedPlaceholder = NSAttributedString(string: "ENTER CAR NUMBER",attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            }
            if (driver.name.count > 0 && driver.number.count > 0){
                print("\(driver.name) - \(driver.name.count) && \(driver.number) - \(driver.number.count)")
                driver.image = helmets[helmetPickerView.selectedRow(inComponent: 0)].pngData()! as NSData
                CoreDataService.saveContext()
                dismiss(animated: true, completion: nil)
            }else{
                CoreDataService.context.delete(driver)
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddDriverTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return helmets.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        return UIImageView(image: helmets[row])
    }
}
