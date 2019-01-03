//
//  AddDriverViewController.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 09/11/2018.
//  Copyright © 2018 Appbryggeriet. All rights reserved.
//

import UIKit

class AddDriverViewController: UIViewController {
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var driverName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
    }
    
    @IBAction func addDriver(_ sender: Any) {
        if let newDriverName = driverName.text, !newDriverName.isEmpty, newDriverName != ""{
            print("navn: \(newDriverName)")
            let driver = Driver(context: CoreDataService.context)
            driver.name = newDriverName
            CoreDataService.saveContext()
            dismiss(animated: true, completion: nil)
        }else {
             driverName.attributedPlaceholder = NSAttributedString(string: "ENTER DRIVER'S NAME HERE",attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        }
    }
    
    @IBAction func cancelAddDriver(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
