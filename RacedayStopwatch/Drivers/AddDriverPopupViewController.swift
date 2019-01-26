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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
    }
    
    func edit(_ driver: Driver){
        print(driver.name)
        //containerView must set driver for use in child view
    }
}
