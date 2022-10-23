//
//  ViewController.swift
//  MemeMe
//
//  Created by Devin Gundry on 10/10/22.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    
    
    @IBOutlet weak var memeView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    let memeTextAttributes = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "Impact", size: 45)!,
        NSAttributedString.Key.strokeWidth: NSNumber(value: -3.0 as Float)
    ]
    
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
        let controller = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        save(memeImage: memeImage)
        present(controller, animated: true, completion: nil)
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
        topText.defaultTextAttributes = memeTextAttributes;
        bottomText.defaultTextAttributes = memeTextAttributes;
        topText.textAlignment = .center
        bottomText.textAlignment = .center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = false //UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
}
    

