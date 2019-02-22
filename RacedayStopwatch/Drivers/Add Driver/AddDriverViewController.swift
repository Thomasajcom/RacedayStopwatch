//
//  AddDriverViewController.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 22/02/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import UIKit

class AddDriverViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var addDriverLabel: UILabel!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var driverNumberLabel: UILabel!
    @IBOutlet weak var pictureOrHelmetLabel: UILabel!
    
    @IBOutlet weak var driverName: UITextField!
    @IBOutlet weak var driverNumber: UITextField!
    @IBOutlet weak var pictureOrHelmetControl: UISegmentedControl!
    
    @IBOutlet weak var pictureContainerView: UIView!
    @IBOutlet weak var helmetContainerView: UIView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addDriverButton: UIButton!
    
    var driver: Driver?
    var driverImage: UIImage?
    var helmetImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius            = 10
        popupView.layer.masksToBounds           = true
        addDriverButton.layer.cornerRadius      = 10
        addDriverButton.layer.masksToBounds     = true
        cancelButton.layer.cornerRadius         = 10
        cancelButton.layer.masksToBounds        = true
        
        driverName.delegate     = self
        driverNumber.delegate   = self
        
        helmetContainerView.isHidden            = true
        
        pictureOrHelmetControl.addTarget(self, action: #selector(changeContainerView), for: .valueChanged)
        
        if let driver = driver {
            driverName.text     = driver.name
            driverNumber.text   = driver.number
            
            addDriverLabel.text = "Edit Driver"
            addDriverButton.setTitle("Save", for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "embedHelmetPickerView"){
            let selectHelmet = segue.destination as! HelmetPickerViewController
            selectHelmet.delegate = self
        }else if (segue.identifier == "embedPicturePickerView"){
            let selectPicture = segue.destination as! DriverPictureViewController
            selectPicture.delegate = self
        }
    }
    
    @objc func changeContainerView(){
        switch pictureOrHelmetControl.selectedSegmentIndex{
        case 0:
            print("i picture view")
            pictureContainerView.isHidden.toggle()
            helmetContainerView.isHidden.toggle()
        case 1:
            print("i helmet view")
            helmetContainerView.isHidden.toggle()
            pictureContainerView.isHidden.toggle()
        default:
            print("default switch selectedSegmentIndex")
        }
    }
    
    // MARK: - Popup Buttons
    @IBAction func save(_ sender: Any) {
        guard let name = driverName.text, name.count > 0 else {
            driverName.placeholder = "A Driver Must Have A Name"
            print("noname")
            return
        }
        guard let number = driverNumber.text, number.count > 0 else {
            driverNumber.placeholder = "A Driver Must Have A Number"
            print("nonumber")
            return
        }
        if pictureContainerView.isHidden{
            driverImage = helmetImage
        }
        guard let image = driverImage else {
            print("no image found")
            return
        }
        
        //edit an existing driver
        if let driver = driver{
            driver.name     = name
            driver.number   = number
            driver.image    = image.pngData()
            CoreDataService.saveContext()
            dismiss(animated: true, completion: nil)
        }
        //save a new driver
        else {
            let driver = Driver(context: CoreDataService.context)
            driver.name = name
            driver.number = number
            driver.image    = image.pngData()
//            let driver = Driver(context: CoreDataService.context)
//            if let newDriverName = driverName.text, !newDriverName.isEmpty, newDriverName != ""{
//                driver.name = newDriverName
//            }else {
//                driverName.attributedPlaceholder = NSAttributedString(string: "ENTER NAME",attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
//            }
//            if let newDriverNumber = driverNumber.text, !newDriverNumber.isEmpty, newDriverNumber != ""{
//                driver.number = newDriverNumber
//            }else{
//                driverNumber.attributedPlaceholder = NSAttributedString(string: "ENTER CAR NUMBER",attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
//            }
            if (driver.name!.count > 0 && driver.number!.count > 0){
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
extension AddDriverViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension AddDriverViewController: HelmetPickerProtocol{
    func selectedHelmet(image: UIImage) {
        print("selectehelmetpiicture!!")
        helmetImage = image
    }
}
extension AddDriverViewController: DriverPictureProtocol{
    func selectedDriverPicture(_ image: UIImage) {
        print("selectedriverpiicture!!")
        driverImage = image
    }
}
