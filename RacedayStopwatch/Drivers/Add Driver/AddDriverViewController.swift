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
        popupView.layer.cornerRadius            = Constants.cornerRadius
        popupView.layer.masksToBounds           = true
        addDriverButton.layer.cornerRadius      = Constants.cornerRadius
        addDriverButton.layer.masksToBounds     = true
        cancelButton.layer.cornerRadius         = Constants.cornerRadius
        cancelButton.layer.masksToBounds        = true
        
        driverName.delegate     = self
        driverNumber.delegate   = self
        
        helmetContainerView.isHidden            = true
        
        pictureOrHelmetControl.addTarget(self, action: #selector(changeContainerView), for: .valueChanged)
        addDriverLabel.text = Constants.ADD_DRIVER_LABEL
        driverNameLabel.text = Constants.DRIVER_NAME_PLACEHOLDER
        driverNumberLabel.text = Constants.DRIVER_NUMBER_PLACEHOLDER
        if let driver = driver {
            driverName.text     = driver.name
            driverNumber.text   = driver.number
            
            addDriverLabel.text = Constants.EDIT_DRIVER_LABEL
            addDriverButton.setTitle(Constants.SAVE_BUTTON_TITLE, for: .normal)
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
            pictureContainerView.isHidden.toggle()
            helmetContainerView.isHidden.toggle()
        case 1:
            helmetContainerView.isHidden.toggle()
            pictureContainerView.isHidden.toggle()
        default:
            print("default switch selectedSegmentIndex")
        }
    }
    
    // MARK: - Popup Buttons
    @IBAction func save(_ sender: Any) {
        guard let name = driverName.text, name.count > 0 else {                            driverName.attributedPlaceholder = NSAttributedString(string: Constants.DRIVER_NAME_PLACEHOLDER_ERROR,attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            return
        }
        guard let number = driverNumber.text, number.count > 0 else {
            driverNumber.attributedPlaceholder = NSAttributedString(string: Constants.DRIVER_NUMBER_PLACEHOLDER_ERROR,attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            return
        }
        if pictureContainerView.isHidden{
            driverImage = helmetImage
        }
        guard let image = driverImage else {
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
        helmetImage = image
    }
}
extension AddDriverViewController: DriverPictureProtocol{
    func selectedDriverPicture(_ image: UIImage) {
        driverImage = image
    }
}
