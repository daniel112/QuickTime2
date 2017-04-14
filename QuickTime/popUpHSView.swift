//
//  popUpHSView.swift
//  QuickTime
//
//  Created by Daniel Yo on 3/18/17.
//  Copyright © 2017 ASU. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
class popUpHSView: UIViewController {

    var topScore:Int?
    var topName:String?
    var gameData = [GameEntity]()// for game 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.showAnimate()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.removeAnimate()
        
    }

    @IBAction func hiscore2(_ sender: Any) {
    }
    
    @IBAction func hiscore1(_ sender: Any) {
    }
    
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "menu2HS2"
        {
            let dest:HS2ViewController = segue.destination as! HS2ViewController
            dest.gameData = gameData
        }
        else if segue.identifier == "menu2HS1"//hs 1
        {
            let dest:HS1ViewController = segue.destination as! HS1ViewController
            dest.gameData = gameData
        }

    }
    

}
