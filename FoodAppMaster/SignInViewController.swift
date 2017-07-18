//
//  SignInViewController.swift
//  FoodAppMaster
//
//  Created by Colton on 7/17/17.
//  Copyright © 2017 Princeton University. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signIn(sender:UIButton!) {
        if usernameText.text != nil && passwordText.text != nil {
        
            if usernameText.text == "morlan" {
                    
                performSegue(withIdentifier: "flappy", sender: nil)
                    
                }
            }

                 }
    
    func signUp(sender:UIButton!) {
        if usernameText.text != nil && passwordText.text != nil {
      
            
        }
    }
    


    
   /* @IBAction func doSomething(sender: UIButton) {
        let propertyToCheck = sender.currentTitle!
        switch propertyToCheck {
        case "signInButton":
        print("in!")
        case "signUpButton":
        print("up")
        default: print("eh")
        }
    }
 */
  

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
