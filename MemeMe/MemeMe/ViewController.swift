//
//  ViewController.swift
//  MemeMe
//
//  Created by Devin Gundry on 10/10/22.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {
    
    
    
    @IBOutlet weak var memeView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    //Text Fields
    let memeTextAttributes = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "Impact", size: 45)!,
        NSAttributedString.Key.strokeWidth: NSNumber(value: -3.0 as Float)
    ]
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == topText){
            if(topText.text == "TOP TEXT") {
                topText.text = ""
            }
        } else if (textField == bottomText){
            if(bottomText.text == "BOTTOM TEXT") {
                bottomText.text = ""
            }
        }
    }
    
    //Image Selection
    @IBAction func imageSelection(_ sender: UIBarButtonItem) {
        if(sender == albumButton){
            imagePickerController(sourceType: .photoLibrary)
        }else{
            imagePickerController(sourceType: .camera)
        }
    }
    func imagePickerController(sourceType: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            memeView.image = image
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    //Share Button
    @IBAction func shareAction(_ sender: Any) {
        let memeImage = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.save(memeImage: memeImage)
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }
    func generateMemedImage() -> UIImage {
        navBar.isHidden = true
        toolBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navBar.isHidden = false
        toolBar.isHidden = false
        
        return memeImage
    }
    func save(memeImage: UIImage) {
        let meme = MemeObject(originalImage: memeView.image!, topText: topText.text!, bottomText: bottomText.text!, editedImage: memeImage)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        setupTextField(textField: topText, text: " TOP ")
        setupTextField(textField: bottomText, text : " BOTTOM ")
    }
    func setupTextField(textField: UITextField, text: String) {
        textField.delegate = self
        textField.text = text
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        textField.autocapitalizationType = .allCharacters
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = false
        subscribeToKeyboardNotifications()

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomText.isFirstResponder {
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
}
    

