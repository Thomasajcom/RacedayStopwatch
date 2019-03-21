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
    
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemNumber: UITextField!
    @IBOutlet weak var pictureOrImageControl: UISegmentedControl!
    
    @IBOutlet weak var pictureContainerView: UIView!
    @IBOutlet weak var imageContainerView: UIView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addItemButton: UIButton!
    
    var driver: Driver?
    var itemIsDriver = false
    var itemImage: UIImage?
    var helmets: [UIImage] = [
        UIImage(named: "helmet_red")!,
        UIImage(named: "helmet_blue")!,
        UIImage(named: "helmet_yellow")!,
        UIImage(named: "helmet_purple")!,
        UIImage(named: "helmet_green")!,
        UIImage(named: "helmet_cyan")!,
        ]
    
    var track: Track?
    var itemIsTrack = false
    var trackImage: UIImage?
    var tracks: [UIImage] = [
        UIImage(named: "helmet_red")!,
        UIImage(named: "helmet_blue")!,
        UIImage(named: "helmet_yellow")!,
        UIImage(named: "helmet_purple")!,
        UIImage(named: "helmet_green")!,
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius            = Constants.cornerRadius
        popupView.layer.masksToBounds           = true
        addItemButton.layer.cornerRadius        = Constants.cornerRadius
        addItemButton.layer.masksToBounds       = true
        cancelButton.layer.cornerRadius         = Constants.cornerRadius
        cancelButton.layer.masksToBounds        = true
        addItemButton.layer.maskedCorners       = [.layerMaxXMaxYCorner]
        cancelButton.layer.maskedCorners        = [.layerMinXMaxYCorner]
        addItemLabel.layer.cornerRadius         = Constants.cornerRadius
        addItemLabel.layer.masksToBounds        = true
        addItemLabel.layer.maskedCorners        = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        itemName.delegate     = self
        itemNumber.delegate   = self
        
        imageContainerView.isHidden            = true
        
        pictureOrImageControl.addTarget(self, action: #selector(changeContainerView), for: .valueChanged)
        
        
        addDoneButton()
        
        pictureOrImageControl.setTitle(Constants.ADD_ITEM_PICTURE_SEGMENT, forSegmentAt: 0)
        addItemButton.setTitle(Constants.SAVE_BUTTON_TITLE, for: .normal)
        itemNameLabel.text   = Constants.ITEM_NAME_LABEL

        if itemIsDriver{
            pictureOrImageControl.setTitle(Constants.ADD_ITEM_HELMETS_SEGMENT, forSegmentAt: 1)
            itemNumberLabel.text = Constants.DRIVER_NUMBER_LABEL
            if let driver = driver {
                itemName.text     = driver.name
                itemNumber.text   = driver.number
                itemName.placeholder     = Constants.DRIVER_NAME_PLACEHOLDER
                itemNumber.placeholder   = Constants.DRIVER_NUMBER_PLACEHOLDER
                addItemLabel.text = Constants.EDIT_DRIVER_LABEL
            }else{
                addItemLabel.text        = Constants.ADD_DRIVER_LABEL
                itemName.placeholder     = Constants.DRIVER_NAME_PLACEHOLDER
                itemNumber.placeholder   = Constants.DRIVER_NUMBER_PLACEHOLDER
            }
        }else if itemIsTrack{
            pictureOrImageControl.setTitle(Constants.ADD_ITEM_TRACKS_SEGMENT, forSegmentAt: 1)
            itemNumberLabel.text = Constants.TRACK_LENGTH_LABEL
            if let track = track {
                itemName.text     = track.name
                if Constants.defaults.bool(forKey: Constants.defaults_metric_key){
                    itemNumber.text   = String(track.length.noDecimals)
                    itemNumber.keyboardType = .numberPad
                }else{
                    itemNumber.text   = String(track.length.fromMetersToMiles().threeDecimals)
                }
                addItemLabel.text = Constants.EDIT_TRACK_LABEL
            }else{
                addItemLabel.text             = Constants.ADD_TRACK_LABEL
                itemName.placeholder          = Constants.TRACK_NAME_PLACEHOLDER
                if Constants.defaults.bool(forKey: Constants.defaults_metric_key){
                    itemNumber.placeholder        = Constants.TRACK_LENGTH_PLACEHOLDER + Constants.LENGTH_UNIT_METERS
                    itemNumber.keyboardType = .numberPad
                }else{
                    itemNumber.placeholder        = Constants.TRACK_LENGTH_PLACEHOLDER + Constants.LENGTH_UNIT_MILES
                }
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupTheme()
    }
    
    func setupTheme(){
        popupView.backgroundColor           = Theme.activeTheme.backgroundColor
        addItemLabel.textColor              = Theme.activeTheme.highlightFontColor
        addItemLabel.backgroundColor        = Theme.activeTheme.highlightColor
        itemNameLabel.textColor             = Theme.activeTheme.mainFontColor
        itemNumberLabel.textColor           = Theme.activeTheme.mainFontColor
        pictureOrImageControl.tintColor     = Theme.activeTheme.tintColor
    }
    //refactor to an extension as it's being used multiple places
    func addDoneButton() {
        let keyboardToolbar             = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexSpace                   = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton               = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items           = [flexSpace, doneBarButton]
        itemName.inputAccessoryView     = keyboardToolbar
        itemNumber.inputAccessoryView   = keyboardToolbar
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "embedImagePickerView"){
            let selectItem = segue.destination as! ImagePickerViewController
            selectItem.delegate   = self
            if itemIsDriver{
                selectItem.images = helmets
            }else if itemIsTrack{
                selectItem.images = tracks
            }
        }else if (segue.identifier == "embedPicturePickerView"){
            let selectPicture = segue.destination as! ItemPictureViewController
            selectPicture.delegate  = self
            if let driver = driver{
                selectPicture.picture = UIImage(data: driver.image!)
            }else if let track = track{
                selectPicture.picture = UIImage(data: track.image!)
            }
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
        guard let name = itemName.text, name.count > 0 else {
            self.itemName.layer.borderColor     = UIColor.red.cgColor
            self.itemName.borderStyle           = .roundedRect
            self.itemName.layer.borderWidth     = 1
            return
        }
        itemName.layer.borderColor = UIColor.clear.cgColor
        guard let number = itemNumber.text, number.count > 0 else {
            self.itemNumber.layer.borderColor   = UIColor.red.cgColor
            self.itemNumber.borderStyle         = .roundedRect
            self.itemNumber.layer.borderWidth   = 1
            return
        }
        itemNumber.layer.borderColor = UIColor.clear.cgColor

        guard let image = itemImage else {
            let alertController = UIAlertController(title: Constants.ADD_ITEM_IMAGE_ERROR_TITLE, message: Constants.ADD_ITEM_IMAGE_ERROR_BODY, preferredStyle: .alert)
            let action = UIAlertAction(title: Constants.ALERT_OK, style: .default, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true)
            return
        }
        
        //edit an existing driver
        if itemIsDriver{
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
        }else if itemIsTrack{
            if let track = track{
                track.name      = name
                if Constants.defaults.bool(forKey: Constants.defaults_metric_key){
                    track.length    = Double(number)!
                }else{
                    track.length    = Double(number)!.fromMilesToMeters()
                }
                track.image     = image.pngData()
                
                CoreDataService.saveContext()
                dismiss(animated: true, completion: nil)
            }else{//save a new track
                let track = Track(context: CoreDataService.context)
                track.name     = name
                if Constants.defaults.bool(forKey: Constants.defaults_metric_key){
                    track.length    = Double(number)!
                }else{
                    track.length    = Double(number)!.fromMilesToMeters()
                }
                track.image    = image.pngData()
                if (track.name!.count > 0 && track.length > 0){
                    CoreDataService.saveContext()
                    dismiss(animated: true, completion: nil)
                }else{
                    CoreDataService.context.delete(track)
                }
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
extension AddItemViewController: ImagePickerProtocol{
    func selectedImage(image: UIImage) {
        itemImage = image
    }
}
extension AddItemViewController: ItemPictureProtocol{
    func selectedItemPicture(_ image: UIImage) {
        itemImage = image
    }
}
