//
//  SendImageViewController.swift
//  LoveInCovid
//
//  Created by apple on 6/2/20.
//  Copyright © 2020 Parrot. All rights reserved.
//

import UIKit



class SendImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var saveImage: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(self.selectImage(gesture:)))
        self.saveImage.isUserInteractionEnabled = true
        self.saveImage.addGestureRecognizer(tapGuesture)
    }
    
    
    @IBAction func camaraButtonPressed(_ sender: Any) {
        print("Camara")
        print("Camara Button Pressed")
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
        else{
            print("You dont have camara!")
        }
        
    }
    
    @objc func selectImage(gesture: UITapGestureRecognizer){
        if(UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imagePicker.dismiss(animated: true, completion: nil)
        let img = info[.originalImage] as? UIImage
        self.saveImage.image = img
    }
   
    
    @IBAction func selectFromGalary(_ sender: UITapGestureRecognizer) {
        print("Image View Clicke")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

    @IBAction func sendButtonPressed(_ sender: Any) {
        
        let box = UIAlertController(
            title: "Image send successful.",
            message: "Successful",
            preferredStyle: .alert
        )
        
        box.addAction(
            UIAlertAction(title: "OK", style: .default, handler: {action in
                            })
        )
        self.present(box, animated: true)
        
    }
}
