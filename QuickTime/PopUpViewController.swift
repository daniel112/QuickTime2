//
//  PopUpViewController.swift
//  QuickTime
//
//  Created by Daniel Yo on 3/16/17.
//  Copyright © 2017 ASU. All rights reserved.
//

import UIKit
import Social

class PopUpViewController: UIViewController {

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
    
    @IBAction func closeOption(_ sender: Any) {
        //self.view.removeFromSuperview()
        self.removeAnimate()
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
    @IBAction func shareButton(_ sender: Any) {
        
        //alert
        let alert = UIAlertController(title: "Share", message: "Share to FaceBook", preferredStyle: .actionSheet)
        //first action
        let actionOne = UIAlertAction(title: "Share This App on FaceBook", style: .default) { (action) in
            //print("success")
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
                let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                post!.setInitialText("A BUNCH OF GIBBERISH TEXT YO")//what you are posting
                //post?.add(<#T##image: UIImage!##UIImage!#>)//add image to post
                post!.add(URL(string:"https://www.apple.com"))
                self.present(post!, animated:true, completion:nil)
                
            }
            else{
                self.showAlert(service:"FaceBook")
            }
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //add action to actionSheet
        alert.addAction(actionOne)
        alert.addAction(actionCancel)
        
        //present alert
        self.present(alert, animated: true, completion:nil)
        
    }
    
    
    @IBAction func aboutButton(_ sender: Any) {
        self.removeAnimate()
    }
    func showAlert(service:String)
    {
        let alert = UIAlertController(title: "Error", message: "You aren't connected to \(service)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated:true, completion: nil)
        
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
