//
//  ViewController.swift
//  MemeMe
//
//  Created by Devin Gundry on 10/10/22.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    
    
    @IBOutlet weak var memeView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var albumButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = false
    }
    
    /*
     Share Button Section
     */
    @IBAction func shareAction(_ sender: Any) {
        shareButton.isHidden = true
        albumButton.isHidden = true
        cameraButton.isHidden = true
        let image = generateMemedImage()
        shareButton.isHidden = false
        albumButton.isHidden = false
        cameraButton.isHidden = false
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
    }
    func generateMemedImage() -> UIImage {

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return memedImage
    }
    /*
     Camera Button Section
     */
    @IBAction func cameraAction(_ sender: Any) {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        present(cameraPicker, animated: true, completion: nil)
    }
    /*
     Album Button Section
     */
    @IBAction func albumAction(_ sender: Any) {
        let albumPicker = UIImagePickerController()
        albumPicker.delegate = self
        present(albumPicker, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            memeView.image = image
            dismiss(animated: true, completion: nil)
            shareButton.isEnabled = true
        }
    }
}

