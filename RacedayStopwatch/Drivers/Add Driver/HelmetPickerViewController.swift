//
//  HelmetPickerViewController.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 22/02/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import UIKit

protocol HelmetPickerProtocol {
    func selectedHelmet(image: UIImage)
}

class HelmetPickerViewController: UIViewController {
    
    var helmets: [UIImage] = [
        UIImage(named: "helmet_red")!,
        UIImage(named: "helmet_blue")!,
        UIImage(named: "helmet_yellow")!,
        UIImage(named: "helmet_purple")!,
        UIImage(named: "helmet_green")!,
        ]
    
    var delegate:HelmetPickerProtocol? = nil

    @IBOutlet weak var helmetPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        helmetPicker.delegate       = self
        helmetPicker.dataSource     = self
        delegate?.selectedHelmet(image: helmets[helmetPicker.selectedRow(inComponent: 0)])

        // Do any additional setup after loading the view.
    }

}

extension HelmetPickerViewController: UIPickerViewDataSource, UIPickerViewDelegate{
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.selectedHelmet(image: helmets[row])
    }
    
}
