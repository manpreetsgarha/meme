//
//  ViewController.swift
//  meme
//
//  Created by Manpreet Singh on 22/10/18.
//  Copyright © 2018 Manpreet Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!

    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled=UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        initTextFields()
    }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    enum BarItems: Int {
        case gallary
        case camera
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image=image
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openImageController(_ sender: UIBarItem) {
        let controller = UIImagePickerController()
        controller.delegate = self
        switch(BarItems(rawValue: sender.tag)!){
        case .camera:
            controller.sourceType = .camera
        case .gallary:
            controller.sourceType = .photoLibrary
        }
        
        present(controller, animated: true, completion: nil)
    }
}

extension ViewController: UITextFieldDelegate{
    
    func initTextFields(){
        topText.delegate=self
        bottomText.delegate=self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField.text == "TOP" || textField.text == "BOTTOM"){
            textField.text=""
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

