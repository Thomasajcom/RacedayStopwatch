//
//  HelmetPickerViewController.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 22/02/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import UIKit

protocol ImagePickerProtocol {
    func selectedImage(image: UIImage)
}

//TODO: - Fix error with selecting first helmet even when editing a driver with another helmet set
class ImagePickerViewController: UIViewController {
    
    var images = [UIImage]()
    
    var delegate:ImagePickerProtocol? = nil
    
    @IBOutlet weak var helmetPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        helmetPicker.delegate       = self
        helmetPicker.dataSource     = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        delegate?.selectedImage(image: images[helmetPicker.selectedRow(inComponent: 0)])
        print("viewdidappear!")
    }
    
}

extension ImagePickerViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return images.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        return UIImageView(image: images[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.selectedImage(image: images[row])
    }
}
