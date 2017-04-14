//
//  PlayViewController.swift
//  QuickTime
//
//  Created by Daniel Yo on 3/16/17.
//  Copyright © 2017 ASU. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {

    @IBOutlet weak var clickMeButton: UIButton!
    @IBOutlet weak var pointTracker: UILabel!
    @IBOutlet weak var barBottom: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var timerText: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var blueText: UIButton!
    @IBOutlet weak var redText: UIButton!
    
    @IBOutlet weak var whiteText: UIButton!
    
    let screenSize = UIScreen.main.bounds
    var points:Int = 0
    var time:Double = 10.0
    var blueTimer:Double = 1.0
    weak var myTimer:Timer?
    var firstButton:Bool = true
    var whiteBall:Bool = false
    var blueBall:Bool = true
    var redBall:Bool = false
    var currentHS:Int?
    
    ///note to dev
    // back button is wired to Exit which wires to unwind segue
    override func viewDidLoad() {
        super.viewDidLoad()
        //get user screen size
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let newY = Int(screenHeight) - 50
        barBottom.frame.size = CGSize(width: screenWidth+50, height: screenHeight * 0.10)//size to match screen size
        barBottom.frame.origin = CGPoint(x: -10, y: newY)//placement to match for any screen size
        
        pointTracker.frame.origin = CGPoint(x: Int(screenWidth) - 90 ,y: newY + 15 )
        backBtn.frame.origin = CGPoint(x: 5 ,y: newY + 12 )
        timerText.frame.origin = CGPoint(x: Int(Double(screenWidth) / 3.0 ), y: newY + 15)
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gameOver()
    {//check if its highest score
        //storyboard name = Main
        let popoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HS1gameOver") as! popUpGame1ScoreViewController
        popoverVC.pScore = self.points
        popoverVC.hScore = currentHS!//pass score value to popup
        self.addChildViewController(popoverVC)
        popoverVC.view.frame = self.view.frame
        self.view.addSubview(popoverVC.view)
        popoverVC.didMove(toParentViewController: self)
        
    }
    
    func advanceTimer(timer: Timer) {
        
        //Total time since timer started, in seconds
        time -= 0.05
        
        //The rest of your code goes here
        
        //Convert the time to a string with 2 decimal places
        let timeString = String(format: "%.2f", time)
        
        //Display the time string to a label in our view controller
        timerText.text = timeString
        
        //GAME OVER
        //once timer reaches 0
        if (time <= 0.0){
            myTimer?.invalidate()
            timerText.text = "Time's up!"
            
            clickMeButton.isHidden = true
            gameOver()//calls function
            
            backBtn.isHidden = false//debug
        }
    }
    
    @IBAction func clickButton(_ sender: Any) {
        
        if(blueBall)
        {
            points += 5
            time += 1
        }
        if(redBall)
        {//maybe lose live instead of points?
            points -= 3
        }
        if(whiteBall)
        {
            points += 8
            time -= 0.5
        }
        
        pointTracker.text = String(points)
        chooseRandomColor()
        spawnBallOnClick()//spawn a new blue after click
        blueTimer = 1.0//reset blue timer so it doesnt spawn again in succession
        
    }
    
    func ballTimer()
    {
        _ = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(spawnBlue), userInfo: nil, repeats: true)// calls method ballTimer every 2 seconds
    }
    
    func spawnBallOnClick()
    {
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let xVal = Int(screenWidth) - 80
        let yVal = Int(screenHeight) - 100
        let randomX = arc4random_uniform(UInt32(xVal)) + 30// range between 20-320
        let randomY = arc4random_uniform(UInt32(yVal))+20// range between 50-650
        clickMeButton.frame.origin = CGPoint(x: Int(randomX), y:Int(randomY))
    }
    
    func chooseRandomColor()
    {
        let rand = arc4random_uniform(10)//0-9
        if(rand >= 0 && rand <= 5)//blue is most common
        {
            clickMeButton.setBackgroundImage(UIImage(named:"blue_circle.png"), for: .normal)
            blueBall = true
            redBall = false
            whiteBall = false
        }
        else if(rand >= 6 && rand <= 8)//red
        {
            clickMeButton.setBackgroundImage(UIImage(named:"red_circle.png"), for: .normal)
            blueBall = false
            redBall = true
            whiteBall = false
        }
        else{// 3  grey
            clickMeButton.setBackgroundImage(UIImage(named:"grey_circle.png"), for: .normal)
            blueBall = false
            redBall = false
            whiteBall = true
        }
    }
    
    func spawnBlue()//called for timer
    {
        blueTimer -= 0.10
        if(blueTimer <= 0 )
        {
            chooseRandomColor()
            spawnBallOnClick()
            blueTimer = 1.0
        }
       
    }
    
    @IBAction func startGame(_ sender: Any) {
        startButton.isHidden = true
        clickMeButton.isHidden = false
        blueText.isHidden = true
        redText.isHidden = true
        whiteText.isHidden = true
        //start game timer
         myTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(advanceTimer(timer:)), userInfo: nil, repeats: true)
        ballTimer()

    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {//segue back to main menu
        let dest:ViewController = segue.destination as! ViewController
        dest.recentScore = points
    }
    

}
