//
//  popUpGame1ScoreViewController.swift
//  QuickTime
//
//  Created by Daniel Yo on 3/28/17.
//  Copyright © 2017 ASU. All rights reserved.
//

import UIKit

class popUpGame1ScoreViewController: UIViewController {

    @IBOutlet weak var yourScoreText: UILabel!
    @IBOutlet weak var highscoreText: UILabel!
    
    @IBOutlet weak var hiscoreText: UILabel!
    @IBOutlet weak var playerScore: UILabel!
    var isHS:Bool?
    var pScore:Int?
    var hScore:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
         self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        playerScore.text = String(pScore!)
        hiscoreText.text = String(hScore!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func toHSButton(_ sender: Any) {
        if pScore! > hScore!
        {
            self.performSegue(withIdentifier: "segueHS1Insert", sender: self)//change view
        }
        else{
            print("CLOSE")
            self.view.removeFromSuperview()
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueHS1Insert"
        {
            let dest:Game1HSViewController = segue.destination as! Game1HSViewController
            dest.score = pScore!//pass the score
            
        }

    }
    

}
