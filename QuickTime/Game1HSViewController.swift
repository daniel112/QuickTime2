//
//  Game1HSViewController.swift
//  QuickTime
//
//  Created by Daniel Yo on 3/18/17.
//  Copyright © 2017 ASU. All rights reserved.
//

import UIKit
import CoreLocation
class Game1HSViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var warningMessage: UILabel!
    @IBOutlet weak var scoreText: UILabel!
    @IBOutlet weak var nameInput: UITextField!
    var score:Int?
    var didClickImgButton:Bool = false
     let picker = UIImagePickerController()// for image picker
    var locationManager: CLLocationManager!//for user location
    var locValue:CLLocationCoordinate2D?
    var picData:NSData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        picker.delegate = self
        warningMessage.isHidden = true
        scoreText.text = String(score!)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirmB(_ sender: Any) {
        if nameInput.text == ""{
            warningMessage.text = "Please Enter a name."
            warningMessage.isHidden = false
        }
        else{
            if didClickImgButton == false{
                warningMessage.text = "Please specify image preference."
                warningMessage.isHidden = false
            }
            else{//all inputs are in boiiii
                self.performSegue(withIdentifier: "back2menu1", sender: self)//change view
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locValue = manager.location!.coordinate
        print("locations = \(locValue!.latitude) \(locValue!.longitude)")
    }

    
    @IBAction func enterImage(_ sender: Any) {
        chooseImageOption()
    }
    
    
    @IBAction func noImgB(_ sender: Any) {
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
        warningMessage.isHidden = true
        let imageData = UIImagePNGRepresentation(chosenImage)// convert it
        picData = imageData! as NSData?
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
         if segue.identifier == "back2menu1"{
            let dest:ViewController = segue.destination as! ViewController
            dest.imgData = picData//pass img data
            dest.recentScore = score!//pass the score
            dest.nameString = self.nameInput.text//pass name
            dest.currLoc = self.locValue
        }
        
    }
    

}
