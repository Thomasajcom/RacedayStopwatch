//
//  AddDriverPopupViewController.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 09/11/2018.
//  Copyright © 2018 Appbryggeriet. All rights reserved.
//

import UIKit

class AddDriverPopupViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var containerView: UIView!
    weak var driverToEdit: Driver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "embedAddDriverPopup"){
            let editDriverPopupVC = segue.destination as! AddDriverTableViewController
            editDriverPopupVC.driver = driverToEdit
            editDriverPopupVC.view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
