//
//  ViewController.swift
//  meme
//
//  Created by Manpreet Singh on 22/10/18.
//  Copyright © 2018 Manpreet Singh. All rights reserved.
//

import UIKit

class EditMemeViewController: UIViewController{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var topBar: UINavigationBar!
    @IBOutlet weak var bottomBar: UIToolbar!

    override func viewDidLoad() {
        initTextFields()
        initShare()
        initImageView()
        initImageViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    fileprivate func setDefaultUi() {
        initTextFields()
        initImageView()
        initShare()
    }
    
    fileprivate func exit() {
        performSegue(withIdentifier: "unwindToSentTabBarController", sender: self)
    }
    
    @IBAction func cancelClick(_ sender: UIBarButtonItem) {
        setDefaultUi()
        exit()
    }
    
    @IBAction func shareClick(_ sender: Any) {
        share()
    }
 }

//MARK: Share Meme Handling
extension EditMemeViewController{
    func initShare(){
        shareButton.isEnabled=false
    }
    func enableShare(){
        shareButton.isEnabled=true
    }
    func share(){
        let meme = getMeme()
        let controller = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler={(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if(completed){
                self.saveMeme(meme: meme)
                self.exit()
            }
        }
        present(controller, animated: true, completion: nil)
    }
}


//MARK: Meme handling
extension EditMemeViewController{
    func handleBar(hidden hide:Bool){
        topBar.isHidden=hide
        bottomBar.isHidden=hide
    }
    
    func saveMeme(meme: Meme){
        // Add it to the memes array on the Application Delegate
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    func getMeme() -> Meme {
        let memedImage = generateMemedImage()
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
        return meme
    }
    
    func generateMemedImage() -> UIImage {
        handleBar(hidden: true)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        handleBar(hidden: false)
        return memedImage
    }
    
}

//MARK: Keyboard handling
extension EditMemeViewController{
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)

    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder && view.frame.origin.y == 0{
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if  view.frame.origin.y != 0{
            view.frame.origin.y = 0
        }
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
}


//MARK: Image handling
extension EditMemeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func initImageViewController(){
        cameraButton.isEnabled=UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
    }
    func initImageView(){
        imageView.image=nil
    }
    enum BarItems: Int {
        case gallary
        case camera
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image=image
            hideTextField(hide: false)
            enableShare() 
        }
    }
    
    @IBAction func openImageController(_ sender: UIBarItem) {
        let controller = UIImagePickerController()
        controller.delegate = self
        switch BarItems(rawValue: sender.tag)! {
        case .camera:
            controller.sourceType = .camera
        case .gallary:
            controller.sourceType = .photoLibrary
        }
       controller.allowsEditing=false
        present(controller, animated: true, completion: nil)
    }
}

//MARK: Textfields handling
extension EditMemeViewController: UITextFieldDelegate{
 
    func initTextFields(){
        let memeTextAttributes:[String: Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: -4]
        setTextField(topTextField, text: "TOP", defaultAttr: memeTextAttributes)
        setTextField(bottomTextField, text: "BOTTOM", defaultAttr: memeTextAttributes)
        hideTextField(hide: true)
    }
    
    
    func setTextField(_ textField: UITextField, text: String, defaultAttr: [String: Any]) {
        textField.delegate = self
        textField.defaultTextAttributes = defaultAttr
        textField.textAlignment = .center
        textField.text = text
        textField.borderStyle = .none
    }
    
    func hideTextField(hide: Bool){
        topTextField.isHidden=hide
        bottomTextField.isHidden=hide
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM"{
            textField.text=""
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

