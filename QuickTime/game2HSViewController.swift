//
//  game2HSViewController.swift
//  QuickTime
//
//  Created by Daniel Yo on 3/18/17.
//  Copyright © 2017 ASU. All rights reserved.
//

import UIKit
import CoreLocation
class game2HSViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var scoreText: UILabel!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var messageText: UILabel!
    var didClickImgButton:Bool = false
    var globalChosenImage:UIImage?
    var playerScore:Int?
    var picData:NSData?
    let picker = UIImagePickerController()// for image picker
    var locationManager: CLLocationManager!//for user location
    var locValue:CLLocationCoordinate2D?
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
       self.hideKeyboardWhenTappedAround()
        locationManager = CLLocationManager()
        locationManager.delegate = self
       locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        scoreText.text = String(playerScore!)
        messageText.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //get location of current
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         locValue = manager.location!.coordinate
        print("locations = \(locValue!.latitude) \(locValue!.longitude)")
    }
    
    
    @IBAction func confirmButton(_ sender: Any) {
        if nameInput.text == ""{
            messageText.text = "Please Enter a name."
             messageText.isHidden = false
        }
        else{
            if didClickImgButton == false{
                messageText.text = "Please specify image preference."
                 messageText.isHidden = false
            }
            else{//all inputs are in boiiii
                self.performSegue(withIdentifier: "back2menu2", sender: self)//change view

            }
        }
        
    }
    
    @IBAction func enterImgButton(_ sender: Any) {
        chooseImageOption()
    }
    
    @IBAction func noImg(_ sender: Any) {
        didClickImgButton = true
    }
    
    func chooseImageOption()
    {
        ///alert controller for image picker (first to show)
        let imageAlertController = UIAlertController(title: "Access image by:", message: "", preferredStyle: .alert)
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            //select an image first
            self.picker.allowsEditing = false
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true, completion: nil)
            
            ////image picker alert
        }
        //use camera
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.picker.allowsEditing = false
            self.picker.sourceType = UIImagePickerControllerSourceType.camera
            self.picker.cameraCaptureMode = .photo
            self.picker.modalPresentationStyle = .fullScreen
            self.present(self.picker,animated: true,completion: nil)
        }
        
        imageAlertController.addAction(libraryAction)
        imageAlertController.addAction(cameraAction)
        self.present(imageAlertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //get chosen image
            image.image = chosenImage
            let imageData = UIImagePNGRepresentation(chosenImage)// convert it
            picData = imageData! as NSData?
        
            messageText.isHidden = true
            didClickImgButton = true
            dismiss(animated:true, completion: nil) //close the library thing
       
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    ///////////photo library stuff
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "back2menu2"
        {
            let dest:ViewController = segue.destination as! ViewController
            dest.imgData = picData//pass img data
            dest.recentScore2Int = playerScore!//pass the score
            dest.nameString = self.nameInput.text//pass name
            dest.currLoc = self.locValue
        }

    }
    

}
