//
//  DriverPictureViewController.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 22/02/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//


import UIKit

protocol ItemPictureProtocol {
    func selectedItemPicture(_ image: UIImage)
}

class ItemPictureViewController: UIViewController {
    
    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var newPhotoButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    
    var delegate: ItemPictureProtocol? = nil
    var driver: Driver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        driverImage.layer.cornerRadius  = Constants.cornerRadius
        driverImage.layer.masksToBounds = true
        if let driver = driver {
            driverImage.image = UIImage(data: driver.image!)
        }else{
            driverImage.image = UIImage(named: "driverImage_placeholder")
        }
        newPhotoButton.setTitle(Constants.CAMERA_TITLE, for: .normal)
        galleryButton.setTitle(Constants.GALLERY_TITLE, for: .normal)
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.allowsEditing = true
        cameraController.delegate = self
        present(cameraController, animated: true)
    }
    
    @IBAction func selectFromGallery(_ sender: UIButton) {
        let cameraController = UIImagePickerController()
        cameraController.allowsEditing = true
        cameraController.delegate = self
        present(cameraController, animated: true)
    }
}
extension ItemPictureViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        driverImage.image = image
        delegate?.selectedItemPicture(image)
    }
    
}