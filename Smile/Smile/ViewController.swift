//
//  ViewController.swift
//  Smile
//
//  Copyright © 2016 Jared Franzone. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var isSmilingLabel: UILabel!

    @IBOutlet weak var smileDectectorImageView: UIImageView!

    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .savedPhotosAlbum
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            smileDectectorImageView.image = image
            detectSmilefrom(image: image) // will add later.
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func importImgButtonTapped(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // Detect Smile
    func detectSmilefrom(image: UIImage) {
        
        // 1
        guard let faceImage = CIImage(image: image) else { return }
        
        // 2
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        
        // 3
        let faces = faceDetector?.features(in: faceImage, options: [CIDetectorSmile: true])
        
        // 4
        if faces?.count == 0 {
            isSmilingLabel.text = "No Face"
        }
        else if faces?.count == 1 {
            if let face = faces?.first as? CIFaceFeature {
                isSmilingLabel.text = (face.hasSmile) ? "Has Smile" : "No Smile"
            }
        }
        else {
            isSmilingLabel.text = "Multiple Faces"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

