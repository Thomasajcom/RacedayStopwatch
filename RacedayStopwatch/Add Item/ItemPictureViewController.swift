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
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var newPhotoButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    
    var delegate: ItemPictureProtocol? = nil
    var picture: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemImage.layer.cornerRadius        = Constants.cornerRadius
        itemImage.layer.masksToBounds       = true
        newPhotoButton.layer.cornerRadius   = Constants.cornerRadius
        newPhotoButton.layer.masksToBounds  = true
        newPhotoButton.layer.maskedCorners  = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        galleryButton.layer.cornerRadius    = Constants.cornerRadius
        galleryButton.layer.masksToBounds   = true
        galleryButton.layer.maskedCorners   = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        if let image = picture {
            itemImage.image = image
            delegate?.selectedItemPicture(image)
        }else{
            itemImage.image = UIImage(named: "itemImage_placeholder")
        }
        //newPhotoButton.setTitle(Constants.CAMERA_TITLE, for: .normal)
        //galleryButton.setTitle(Constants.GALLERY_TITLE, for: .normal)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupTheme()
    }
    
    func setupTheme() {
        view.backgroundColor            = Theme.activeTheme.backgroundColor
        newPhotoButton.backgroundColor  = Theme.activeTheme.foregroundColor
        newPhotoButton.tintColor        = Theme.activeTheme.tintColor
        galleryButton.backgroundColor   = Theme.activeTheme.foregroundColor
        galleryButton.tintColor         = Theme.activeTheme.tintColor
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraController            = UIImagePickerController()
            cameraController.sourceType     = .camera
            cameraController.allowsEditing  = true
            cameraController.delegate       = self
            present(cameraController, animated: true)
        }
        
    }
    
    @IBAction func selectFromGallery(_ sender: UIButton) {
        let cameraController            = UIImagePickerController()
        cameraController.allowsEditing  = true
        cameraController.delegate       = self
        present(cameraController, animated: true)
    }
}
extension ItemPictureViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        itemImage.image = image
        delegate?.selectedItemPicture(image)
    }
    
}
