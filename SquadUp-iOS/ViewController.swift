//
//  ViewController.swift
//  SquadUp-iOS
//
//  Created by Shaheen Sharifian on 1/23/16.
//  Copyright © 2016 Shaheen Sharifian. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyJSON

var CURRENT_USER: UserModel!

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var usersArray: [UserModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(SEGUE_LOGGEDIN, sender: nil)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func facebookButtonPressed(sender: UIButton!) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"]) { (facebookResult: FBSDKLoginManagerLoginResult!, facebookError: NSError!) -> Void in
            if facebookError != nil {
                print("Facebook Error \(facebookError.description)")
                // Maybe put a pop up notification
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Facebook Login Successful")
                // Perform Authentication
                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, AuthData in
                    
                    if error != nil {
                        print("Login Failed")
                    } else {
                        print("Logged in")
                        // Create Firebase User
                        // TODO: Find Post History for Facebook User
                        let posts = []
                        let sports = []
                        let user = ["provider": AuthData.provider!, "id": "user", "gender": "male", "firstName": "Shaheen","lastName": "Sharifian", "posts": "hullo"]
                        let currentUser: UserModel = UserModel(key: "user", firstName: "Shaheen", lastName: "Sharifian", gender: "Male", userId: "currentUser", posts: posts as! [String], sports: sports as! [String])
                        
                        let defaults = NSUserDefaults.standardUserDefaults()
                        let UserModelKey = "userModelKey"
                        let currentUserData = NSKeyedArchiver.archivedDataWithRootObject(currentUser)
                        defaults.setObject(currentUserData, forKey: UserModelKey)
                        
                        DataService.ds.createFirebaseUser(AuthData.uid, user: user)
                        NSUserDefaults.standardUserDefaults().setValue(AuthData.uid, forKey: KEY_UID)
                        self.performSegueWithIdentifier("LoggedIn", sender: nil)
                    }
                    
                })
                
            }
        }
    }
    
    // For email
    @IBAction func attemptLogin(sender: UIButton!) {
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
            
            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error, Authdata in
                if error != nil {
                    print(error.code)
                    
                    if error.code == STATUS_ACCOUNT_NON_EXIST {
                        DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { error, result in
                            // Print Error Codes
                            if error != nil {
                                self.showErrorAlert("Could not Create Account", msg: "Problem Creating Account")
                                // Possible cases
                                // Invalid password, Already exists, incorrect email
                            } else {
                                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                                
                                DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error, AuthData in
                                    let user = ["provider": AuthData.provider!, "Blah": "Emailtest"]
                                    DataService.ds.createFirebaseUser(AuthData.uid, user: user)
                                })
                                self.performSegueWithIdentifier(SEGUE_LOGGEDIN, sender: nil)
                            }
                        })
                    } else {
                        self.showErrorAlert("Could Not LogIn", msg: "Please check your Username or Password")
                    }
                }
                else {
                    self.performSegueWithIdentifier(SEGUE_LOGGEDIN, sender: nil)
                }
            })
            
        } else {
            showErrorAlert("Email and Password Required", msg: "You must enter an Email and Password")
        }
    }
    
    
    
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
}

