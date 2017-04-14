//
//  ColorGameViewController.swift
//  QuickTime
//
//  Created by Daniel Yo on 3/16/17.
//  Copyright © 2017 ASU. All rights reserved.
//

import UIKit

class ColorGameViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
  
    
    @IBOutlet weak var btTop: UIButton!
    @IBOutlet weak var btLeft: UIButton!
    @IBOutlet weak var btRight: UIButton!
    @IBOutlet weak var btBot: UIButton!
    
    @IBOutlet weak var finalPointsText: UILabel!
    @IBOutlet weak var livesText: UILabel!
    @IBOutlet weak var pointsText: UILabel!
    @IBOutlet weak var displayColorText: UILabel!
    //for color rotation
    //implement queue to rotate color images
    //string queues to store the file name
    
    let screenSize = UIScreen.main.bounds
    //for hard version
    var arrayX = [Int]()
    var arrayY = [Int]()
    var foundLocation:Bool = false
    
    var time:Double = 10.0
    weak var myTimer:Timer?
    var totalPoints:Int = 0
    var lives:Int = 1
    var currentHS:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //ballTimer()//enables random rotation
        //set the button tap function to "buttonActionColorRotate
        btTop.addTarget(self, action: #selector(buttonActionColorRotate), for: .touchUpInside)
        btBot.addTarget(self, action: #selector(buttonActionColorRotate), for: .touchUpInside)
        btLeft.addTarget(self, action: #selector(buttonActionColorRotate), for: .touchUpInside)
        btRight.addTarget(self, action: #selector(buttonActionColorRotate), for: .touchUpInside)
        livesText.text = String(lives)
        displayColor()
        backBtn.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func spawnTest(_ sender: Any) {
        //spawnBalls()
        //rotateClockwise()
        //rotateCounterClockwise()
        //displayColor()
    }

    func displayColor()
    {
         let rando = arc4random_uniform(4)//0,1,2,3
        if(rando == 0 && displayColorText.text != "BLUE")
        {
            displayColorText.text = "BLUE"
            displayColorText.textColor = UIColor(netHex:0x007acc)
        }
        else if( rando == 1 && displayColorText.text != "RED"){
            displayColorText.text = "RED"
            displayColorText.textColor = UIColor(netHex:0xff6600)
        }
        else if( rando == 2 && displayColorText.text != "WHITE"){
            displayColorText.text = "WHITE"
            displayColorText.textColor = UIColor(netHex:0x595959)
        }
        else if(rando == 3 && displayColorText.text != "GREEN"){
            displayColorText.text = "GREEN"
            displayColorText.textColor = UIColor(netHex:0x29a329)
        }
        else{
            displayColor()
        }
    }
    
    
    
    func ballTimer()
    {
        myTimer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(randomRotation), userInfo: nil, repeats: true)// calls method ballTimer every 1 seconds
    }

    func randomRotation()//called for timer
    {
        
        let rand = arc4random_uniform(2)//0 or 1
        if(rand == 0)
        {
            rotateClockwise()
        }
        else
        {
            rotateCounterClockwise()
        }
        //print(rand)
    }
    
    //color rotation game
    func rotateClockwise()
    {
        //UIView.beginAnimations(nil, context: nil)//animation of swapping
        //(get origin of top,right,bot,left) = (set origin to)
        (btTop.frame.origin, btRight.frame.origin, btBot.frame.origin, btLeft.frame.origin) = (btRight.frame.origin, btBot.frame.origin, btLeft.frame.origin, btTop.frame.origin)//move clockwise
        
        //UIView.commitAnimations()
        
    }
    func rotateCounterClockwise()
    {
        (btTop.frame.origin, btRight.frame.origin, btBot.frame.origin, btLeft.frame.origin) = (btLeft.frame.origin, btTop.frame.origin, btRight.frame.origin, btBot.frame.origin)//move clockwise
    }
    
    func buttonActionColorRotate(sender: UIButton!) {//when a ball is clicked
        let btnsendtag: UIButton = sender
        if btnsendtag.tag == 1 {//blue
            if displayColorText.text == "BLUE"{
                totalPoints += 1
            }
            else{
                lives -= 1
            }
        }
        else if btnsendtag.tag == 2{//red
            if displayColorText.text == "RED"{
                totalPoints += 1
            }
            else{
                lives -= 1
            }
        }
        else if btnsendtag.tag == 3{//white
            if displayColorText.text == "WHITE"{
                totalPoints += 1
            }
            else{
                lives -= 1
            }
        }
        else if btnsendtag.tag == 4{//green
            if displayColorText.text == "GREEN"{
                totalPoints += 1
            }
            else{
                lives -= 1
            }
        }
        //update points and lives and change text
        displayColor()//change color text
        pointsText.text = String(totalPoints)
        livesText.text = String(lives)
        //GAME OVER CONDITION
        if(lives <= 0)//0 lives = lose
        {
            myTimer?.invalidate()//stop timer function
            backBtn.isHidden = false
            finalPointsText.isHidden = false
            finalPointsText.text = "Score: \(totalPoints)"
            //hide balls
            btTop.isHidden = true
            btRight.isHidden = true
            btBot.isHidden = true
            btLeft.isHidden = true
            showHSPopUp()
        }
    }
    
    func showHSPopUp()
    {
        //storyboard name = Main
        let popoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HS2gameOver") as! popUpGame2ScoreViewController
        popoverVC.pScore = self.totalPoints
        popoverVC.hScore = currentHS// placeholder score
        //pass score value to popup 
        self.addChildViewController(popoverVC)
        popoverVC.view.frame = self.view.frame
        self.view.addSubview(popoverVC.view)
        popoverVC.didMove(toParentViewController: self)
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}

/* usage
 var color = UIColor(red: 0xFF, green: 0xFF, blue: 0xFF)
 var color2 = UIColor(netHex:0xFFFFFF)
 */
extension UIColor {//for hexcolor
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
