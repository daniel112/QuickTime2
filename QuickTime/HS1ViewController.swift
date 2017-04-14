//
//  HS1ViewController.swift
//  QuickTime
//
//  Created by Daniel Yo on 3/18/17.
//  Copyright © 2017 ASU. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import MapKit
class HS1ViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var scoreText: UILabel!
    @IBOutlet weak var nameText: UILabel!
    
    var gameData = [GameEntity]()// for game 1
    override func viewDidLoad() {
        super.viewDidLoad()
        checkHsExist()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkHsExist()
    {
        print(gameData.count)
        for i in 0..<gameData.count{
            if gameData[i].gameType == "game1"{
                nameText.text = gameData[i].name!
                scoreText.text = String(gameData[i].points)
                let long = gameData[i].long
                let lat = gameData[i].lat
                //for image//
                if gameData[i].pic != nil{
                    //cast the core data image to UIImage
                    let img = UIImage(data: gameData[i].pic! as Data)
                    image.image = img
                }
                
                print(long)
                print(lat)
                openMapForPlace(long:long , lat: lat)
                return
            }
        }
        print("No game 1 data yet.")
        nameText.text = "nil"
    }
    
    func openMapForPlace(long:Double, lat:Double) {
        
        let lon : CLLocationDegrees = long
        
        let lat : CLLocationDegrees = lat
        
        let coordinates = CLLocationCoordinate2D( latitude: lat, longitude: lon)
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        
        let region: MKCoordinateRegion = MKCoordinateRegionMake(coordinates, span)
        
        self.map.setRegion(region, animated: true)
        
        // add an annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = "Winner Location"
        annotation.subtitle = "Where they got their Hiscore"
        
        self.map.addAnnotation(annotation)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
