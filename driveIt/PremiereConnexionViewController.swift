//
//  PremiereConnexionViewController.swift
//  driveIt
//
//  Created by utilisateur on 14/07/2017.
//  Copyright © 2017 SVInfo. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PremiereConnexionViewController: UIViewController {

    @IBOutlet weak var pseudoText: UITextField!
    @IBOutlet weak var nomText: UITextField!
    @IBOutlet weak var prenomText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // on test si l'utilisateur est connu
        // si oui, on enchaine sur l'écran d'accueil
        // sinon, on demande la saisie d'un nom, prénom. L'id sera l'email de connexion
        
        let referenceTable = DataService.dataService.RESOURCES.queryOrdered(byChild: "id").queryEqual(toValue: LoginEmailViewController.currentUser)
        
        referenceTable.observeSingleEvent(of: .value, with: { (snapshot) in
            if (snapshot.childrenCount > 0) {
                self.performSegue(withIdentifier: "segueFirstAccueil", sender: self)
            }
        })
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ValiderTapped(_ sender: Any) {
        if (pseudoText.text != "" && nomText.text != "" && prenomText.text != "") {
            let referenceTable: DatabaseReference = DataService.dataService.RESOURCES
            
            let AAjouter = ["id": LoginEmailViewController.currentUser, "nom": nomText.text, "prenom": prenomText.text, "pseudo": pseudoText.text]
            referenceTable.childByAutoId().setValue(AAjouter)
            
            self.performSegue(withIdentifier: "segueFirstAccueil", sender: self)
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


/*

let referenceTable = DataService.dataService.L_SKILLS_RESSOURCES.queryOrdered(byChild: "idResource").queryEqual(toValue: CompetencesTableViewController.currentResource)

referenceTable.observe(DataEventType.value, with: { (snapshot) in
    if snapshot.childrenCount > 0 {
        self.competences.removeAll()
        
        for competence in snapshot.children.allObjects as! [DataSnapshot] {
            
            let Objet = competence.value as? [String: AnyObject]
            
            let competenceId = Objet?["id"]
            let competenceName = Objet?["name"]
            let competenceLevel = Objet?["level"]
            let competenceIdResource = Objet?["idResource"]
            
            let currentObjet = LSkillRessource(id: competenceId as? String, name: competenceName as? String, level: competenceLevel  as? String, idResource: competenceIdResource as? String)
            
            self.competences.append(currentObjet)
        }
        
        self.tableView.reloadData()
    }
})
}
*/
