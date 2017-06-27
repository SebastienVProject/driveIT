//
//  LoginEmailViewController.swift
//  driveIt
//
//  Created by utilisateur on 22/06/2017.
//  Copyright © 2017 SVInfo. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginEmailViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var choixControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func forgotPasswordTapped(_ sender: UIButton) {
        if !((emailText.text?.isEmpty)!) {
            Auth.auth().sendPasswordReset(withEmail: emailText.text!, completion: nil)
        }
    }

    @IBAction func loginTapped(_ sender: UIButton) {
        
        if !(emailText.text?.isEmpty)! && !(passwordText.text?.isEmpty)! {
            if choixControl.selectedSegmentIndex == 0 {
                //sign in
                Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!, completion: { (user: User?, error: Error?) in
                    if user != nil{
                        //actions quand le log in est ok à renseigner ici
                        self.performSegue(withIdentifier: "segueLoginAccueil", sender: self)
                    } else {
                        if let myError = error?.localizedDescription {
                            print(myError)
                        } else {
                            print("ERREUR")
                        }
                    }
                })
            } else {
                //sign up
                Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!, completion: { (user, error) in
                    if user != nil {
                        print("utilisateur créé avec succès")
                        self.performSegue(withIdentifier: "segueLoginAccueil", sender: self)
                    } else {
                        if let myError = error?.localizedDescription {
                            print(myError)
                        } else {
                            print("ERREUR")
                        }
                    }
                })
            }
        } else {
            // saisir au préalable les informations nécessaires
        }
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
