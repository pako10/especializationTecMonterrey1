//
//  cameraViewController.swift
//  proyectoFinalTec
//
//  Created by Francisco Humberto Andrade Gonzalez on 22/04/16.
//  Copyright © 2016 Francisco Humberto Andrade Gonzalez. All rights reserved.
//

import UIKit

protocol DestinationViewControllerDelegate {
    func doSomethingWithData(data: UIImage)
}

class cameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var pictureShowed: UIImageView!
    @IBOutlet weak var btnCameraOutlet: UIBarButtonItem!
    
    private let myPicker = UIImagePickerController()
    var pictureForRoute: Bool = false
    
    var delegate: DestinationViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if !UIImagePickerController.isSourceTypeAvailable(.Camera){
            btnCameraOutlet.enabled = false
            let alert = UIAlertController(title: "Hardware failure", message: "La cámara no se encuentra", preferredStyle: .Alert)
            let actionOk = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(actionOk)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        myPicker.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnAlbum(sender: AnyObject) {
        myPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(myPicker, animated: true, completion: nil)

    }
    
    @IBAction func btnCamera(sender: AnyObject) {
        myPicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(myPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        pictureShowed.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnSave(sender: AnyObject) {
        if (pictureShowed.image != nil ){
            if(pictureForRoute == true){
                navigationController?.popViewControllerAnimated(true)
                delegate?.doSomethingWithData(pictureShowed.image!)
            }
            else{
                UIImageWriteToSavedPhotosAlbum(pictureShowed.image!, nil, nil, nil)
                let alert = UIAlertController(title: "It's ok!", message: "Picture saved", preferredStyle: .Alert)
                let actionOk = UIAlertAction(title: "OK", style: .Default, handler: {
                    action in
                    
                })
                alert.addAction(actionOk)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        else {
            let alert = UIAlertController(title: "error!", message: "Not picture saved", preferredStyle: .Alert)
            let actionOk = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(actionOk)
            self.presentViewController(alert, animated: true, completion: nil)
        }
 
        
    }
   

}
