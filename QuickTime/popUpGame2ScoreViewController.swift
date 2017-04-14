//
//  popUpGame2ScoreViewController.swift
//  QuickTime
//
//  Created by Daniel Yo on 3/28/17.
//  Copyright © 2017 ASU. All rights reserved.
//

import UIKit

class popUpGame2ScoreViewController: UIViewController {

    @IBOutlet weak var playerScoreText: UILabel!
    @IBOutlet weak var hiscoreText: UILabel!
    var pScore:Int?
    var hScore:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
         self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        playerScoreText.text = String(pScore!)
        hiscoreText.text = String(hScore!)
        //print(pScore)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func nextButton(_ sender: Any) {
        //if personScore > highSore go to next screen
        if pScore! > hScore!
        {
            self.performSegue(withIdentifier: "segueHS2Insert", sender: self)//change view
        }
        else{
            print("CLOSE")
            self.view.removeFromSuperview()
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueHS2Insert"
        {
            let dest:game2HSViewController = segue.destination as! game2HSViewController
            dest.playerScore = pScore!//pass the score
            
        }
    }
    

}
