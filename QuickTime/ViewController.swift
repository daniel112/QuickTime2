//
//  ViewController.swift
//  QuickTime
//
//  Created by Daniel Yo on 3/16/17.
//  Copyright © 2017 ASU. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import MapKit

class ViewController: UIViewController, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {


    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var hiscoreBt: UIButton!
    @IBOutlet weak var optBt: UIButton!
    @IBOutlet weak var recentScoreText: UILabel!
    @IBOutlet weak var recentScore2: UILabel!
    
    @IBOutlet weak var deleteTest: UIButton!
    let screenSize = UIScreen.main.bounds
    var recentScore:Int = 0
    var recentScore2Int:Int = 0// data being manipulated from game2HSView
    //core data declaration
    var gameInfo = [GameEntity]()// for game 1
    var GameContext:NSManagedObjectContext!
    //variable to save to coreData
    var nameString:String?
    var imgData:NSData?
    var currLoc:CLLocationCoordinate2D?//obtained from HS input 1 and 2
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide debugger
       // recentScoreText.isHidden = true
       // recentScore2.isHidden = true
       // deleteTest.isHidden = true
        
        ///
        
        // Do any additional setup after loading the view, typically from a nib.
        //button image
        buttonPlay.setBackgroundImage(UIImage(named: "buttonPress.png")!, for: .highlighted)
        buttonPlay.setBackgroundImage(UIImage(named: "idleButton.png")!, for: .normal)
        hiscoreBt.setBackgroundImage(UIImage(named: "buttonPress.png")!, for: .highlighted)
        hiscoreBt.setBackgroundImage(UIImage(named: "idleButton.png")!, for: .normal)
        optBt.setBackgroundImage(UIImage(named: "buttonPress.png")!, for: .highlighted)
        optBt.setBackgroundImage(UIImage(named: "idleButton.png")!, for: .normal)
        
        GameContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        loadData()
        recentScore2.text = String(recentScore2Int)
        printDebugCoreData()
        fetchHSRecord()
        
      
    }

    
    func fetchHSRecord()//update UI with record
    {
        for i in 0..<fetchRecord(){
            if gameInfo[i].gameType == "game2"{
                recentScore2Int = Int(gameInfo[i].points)
                recentScore2.text = String(recentScore2Int)
            }
            
        }
    }
    func fetchRecord() -> Int {//get the total number of record in core data
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameEntity")
        var x   = 0
        // Execute the fetch request, and cast the results to an array of LogItem objects
        gameInfo = ((try? GameContext.fetch(fetchRequest)) as? [GameEntity])!
        
        x = gameInfo.count
        print(x)
        return x
    }

    
    func loadData()//load coreData into gameInfo
    {
        let gameRequest:NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
        
        do{
            gameInfo = try GameContext.fetch(gameRequest)
           
        }catch{
            print("Could not load data for coredata.")
        }
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func playButton(_ sender: Any) {
       
        
    }
    
    //popup
    @IBAction func optionPop(_ sender: Any) {
        let popoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "optionPopUp") as! PopUpViewController
        self.addChildViewController(popoverVC)
        popoverVC.view.frame = self.view.frame
        self.view.addSubview(popoverVC.view)
        popoverVC.didMove(toParentViewController: self)
    }

    //popup
    @IBAction func hiscorePop(_ sender: Any) {
        let popoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HSpopup") as! popUpHSView
        self.addChildViewController(popoverVC)
        popoverVC.view.frame = self.view.frame
        //get name from HS coreData//////
        loadData()//reload data again before sending info
        popoverVC.gameData = gameInfo
        //////////////////////////////////
        self.view.addSubview(popoverVC.view)
        popoverVC.didMove(toParentViewController: self)

    }
    
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "game1"
        {
            let dest:PlayViewController = segue.destination as! PlayViewController
            dest.currentHS = recentScore//pass the HS

        }
        else if segue.identifier == "game2"{
            let dest:ColorGameViewController = segue.destination as! ColorGameViewController
            dest.currentHS = recentScore2Int//pass the HS
        }
    
    }
    
    
    //test delete all data in coredata
    @IBAction func deleteData(_ sender: Any) {
       deleteCoreD()
    }
    
    
    func checkIfdataExist(gType:String) -> (Bool, Int)//check if a hs already exist
    {
        //let index:Int?
        for i in 0..<fetchRecord(){
            //index = i
            if gameInfo[i].gameType == gType{
                return (true, i)
            }
        }
        return (false,0)
    }
    
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {//from game one
        //coredata save here
        let checker = checkIfdataExist(gType: "game1")
        let checkExist:Bool = checker.0
        let indexChecker:Int = checker.1
        if !checkExist{//create new data for it
            print("CREATING NEW DATA")
            let gameItem = GameEntity(context: GameContext)
            gameItem.points = Int16(recentScore)
            gameItem.name =  nameString!
            gameItem.gameType = "game1"
            gameItem.pic = imgData
            gameItem.lat = currLoc!.latitude
            gameItem.long = currLoc!.longitude
            do {
                try self.GameContext.save()
            } catch _ {
                print("Could not save data.")
            }
            
        }
        else{//if theres a score already exist, replace it
            print("REPLACING AN ALREADY EXISTING DATA")
            gameInfo[indexChecker].name = nameString!
            gameInfo[indexChecker].pic = imgData
            gameInfo[indexChecker].points = Int16(recentScore2Int)
            gameInfo[indexChecker].lat = currLoc!.latitude
            gameInfo[indexChecker].long = currLoc!.longitude
            do {
                try self.GameContext.save()
            } catch _ {
                print("Could not save data.")
            }
        }
        recentScoreText.text = String(recentScore)
        
    }
    ///note to dev
    // back button is wired to Exit which wires to unwind segue
     @IBAction func unwindFromGame2HS(segue: UIStoryboardSegue) {
        //coredata save here
        let checker = checkIfdataExist(gType: "game2")
        let checkExist:Bool = checker.0
        let indexChecker:Int = checker.1
        if !checkExist{//create new data for it
            print("CREATING NEW DATA")
            let gameItem = GameEntity(context: GameContext)
            gameItem.points = Int16(recentScore2Int)
            gameItem.name =  nameString!
            gameItem.gameType = "game2"
            gameItem.pic = imgData
            gameItem.lat = currLoc!.latitude
            gameItem.long = currLoc!.longitude
            do {
                try self.GameContext.save()
            } catch _ {
                print("Could not save data.")
            }

        }
        else{//if theres a score already exist, replace it
            print("REPLACING AN ALREADY EXISTING DATA")
            gameInfo[indexChecker].name = nameString!
            gameInfo[indexChecker].pic = imgData
            gameInfo[indexChecker].points = Int16(recentScore2Int)
             gameInfo[indexChecker].lat = currLoc!.latitude
             gameInfo[indexChecker].long = currLoc!.longitude
            do {
                try self.GameContext.save()
            } catch _ {
                print("Could not save data.")
            }
        }
        recentScore2.text = String(recentScore2Int)
        //printDebugCoreData()

    }
    
    @IBAction func unwindFromHS2VC(segue: UIStoryboardSegue) {
        //coming from HS2VC
    }
    
    @IBAction func unwindFromHS1VC(segue: UIStoryboardSegue) {
        //coming from HS1VC
    }
    
    
    //////////////////////////////////////////
    ///DEBUGGING FUNCTIONS
    func printDebugCoreData(){
        print("PRINT DAT")
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameEntity")
        
        // Configure Fetch Request
        fetchRequest.includesPropertyValues = true
        do {
            let items = try self.GameContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for item in items {
                print(item)
            }
            
        } catch {
            // Error Handling
            // ...
        }
        
    }
    
    func deleteCoreD(){
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameEntity")
        
        // Configure Fetch Request
        fetchRequest.includesPropertyValues = false
        
        do {
            let items = try self.GameContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for item in items {
                self.GameContext.delete(item)
            }
            
            // Save Changes
            try self.GameContext.save()
            print("DELETED")
            
        } catch {
            // Error Handling
            // ...
        }
    }
    
}

// to dismiss keyboard
//self.hideKeyboardWhenTappedAround() in viewdidload
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

