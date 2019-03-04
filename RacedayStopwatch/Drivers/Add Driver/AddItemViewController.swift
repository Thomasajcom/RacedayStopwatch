//
//  AddItemViewController.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 22/02/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var addItemLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemNumberLabel: UILabel!
    @IBOutlet weak var pictureOrImageLabel: UILabel!
    
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemNumber: UITextField!
    @IBOutlet weak var pictureOrImageControl: UISegmentedControl!
    
    @IBOutlet weak var pictureContainerView: UIView!
    @IBOutlet weak var imageContainerView: UIView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addItemButton: UIButton!
    
    var driver: Driver?
    var driverImage: UIImage?
    var helmetImage: UIImage?
    
    var track: Track?
    var trackImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius            = Constants.cornerRadius
        popupView.layer.masksToBounds           = true
        addItemButton.layer.cornerRadius      = Constants.cornerRadius
        addItemButton.layer.masksToBounds     = true
        cancelButton.layer.cornerRadius         = Constants.cornerRadius
        cancelButton.layer.masksToBounds        = true
        
        itemName.delegate     = self
        itemNumber.delegate   = self
        
        imageContainerView.isHidden            = true
        
        pictureOrImageControl.addTarget(self, action: #selector(changeContainerView), for: .valueChanged)
        addItemLabel.text             = Constants.ADD_DRIVER_LABEL
        itemNameLabel.text            = Constants.DRIVER_NAME_PLACEHOLDER
        itemNumberLabel.text          = Constants.DRIVER_NUMBER_PLACEHOLDER
        addDoneButton()
        pictureOrImageLabel.text       = Constants.ADD_DRIVER_PICTURE_OR_HELMET_LABEL
        pictureOrImageLabel.isHidden   = true
        pictureOrImageControl.setTitle(Constants.ADD_DRIVER_PICTURE_SEGMENT, forSegmentAt: 0)
        pictureOrImageControl.setTitle(Constants.ADD_DRIVER_HELMET_SEGMENT, forSegmentAt: 1)
        if let driver = driver {
            itemName.text     = driver.name
            itemNumber.text   = driver.number
            
            addItemLabel.text = Constants.EDIT_DRIVER_LABEL
            addItemButton.setTitle(Constants.SAVE_BUTTON_TITLE, for: .normal)
        }
    }
    //refactor to an extension as it's being used multiple places
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexSpace, doneBarButton]
        itemNumber.inputAccessoryView = keyboardToolbar
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "embedHelmetPickerView"){
            let selectHelmet = segue.destination as! HelmetPickerViewController
            selectHelmet.delegate   = self
        }else if (segue.identifier == "embedPicturePickerView"){
            let selectPicture = segue.destination as! DriverPictureViewController
            selectPicture.delegate  = self
            selectPicture.driver    = driver
        }
    }
    
    @objc func changeContainerView(){
        switch pictureOrImageControl.selectedSegmentIndex{
        case 0:
            pictureContainerView.isHidden.toggle()
            imageContainerView.isHidden.toggle()
        case 1:
            imageContainerView.isHidden.toggle()
            pictureContainerView.isHidden.toggle()
        default:
            print("default switch selectedSegmentIndex")
        }
    }
    
    // MARK: - Popup Buttons
    @IBAction func save(_ sender: Any) {
        guard let name = itemName.text, name.count > 0 else {                            itemName.attributedPlaceholder = NSAttributedString(string: Constants.DRIVER_NAME_PLACEHOLDER_ERROR,attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            return
        }
        guard let number = itemNumber.text, number.count > 0 else {
            itemNumber.attributedPlaceholder = NSAttributedString(string: Constants.DRIVER_NUMBER_PLACEHOLDER_ERROR,attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            return
        }
        if pictureContainerView.isHidden{
            driverImage = helmetImage
        }
        guard let image = driverImage else {
            let alertController = UIAlertController(title: Constants.ADD_DRIVER_IMAGE_ERROR_TITLE, message: Constants.ADD_DRIVER_IMAGE_ERROR_BODY, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true)
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
            driver.name     = name
            driver.number   = number
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
extension AddItemViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//TODO: - rework these to one variable and automatically understanding which one the user wants
extension AddItemViewController: HelmetPickerProtocol{
    func selectedHelmet(image: UIImage) {
        helmetImage = image
    }
}
extension AddItemViewController: DriverPictureProtocol{
    func selectedDriverPicture(_ image: UIImage) {
        driverImage = image
    }
}
