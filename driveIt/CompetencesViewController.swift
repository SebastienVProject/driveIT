//
//  CompetencesViewController.swift
//  driveIt
//
//  Created by utilisateur on 26/06/2017.
//  Copyright © 2017 SVInfo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CompetencesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewCompetence: UITableView!
    
    var competences = [LSkillRessource]()
    
    static var currentResource: String!
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let referenceTable = DataService.dataService.L_SKILLS_RESSOURCES.queryOrdered(byChild: "idResource").queryEqual(toValue: CompetencesViewController.currentResource)
        
        referenceTable.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.competences.removeAll()
                
                for competence in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let competenceObjet = competence.value as? [String: AnyObject]
                    
                    let competenceId = competenceObjet?["id"]
                    let competenceName = competenceObjet?["name"]
                    let competenceLevel = competenceObjet?["level"]
                    let competenceIdResource = competenceObjet?["idResource"]
                    
                    let currentCompetence = LSkillRessource(id: competenceId as? String, name: competenceName as? String, level: competenceLevel as? Int, idResource: competenceIdResource as? String)
                    
                    self.competences.append(currentCompetence)
                }
                
                self.tableViewCompetence.reloadData()
            }
        })
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "segueRessourceCompetence" {
//            let ExigenceTransmise: Requirement = sender as! Requirement
//            TachesViewController.currentExigence = ExigenceTransmise.id
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return competences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let currentCompetence: LSkillRessource
        currentCompetence = competences[indexPath.row]
        
        Cell.textLabel?.text = currentCompetence.name
        return Cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        let currentCompetence: Skill = competences[indexPath.row]
//        performSegue(withIdentifier: "segueRessourceCompetence", sender: currentCompetence)
//    }
    
    @IBAction func AddTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Ajouter une compétence", message: "Merci de saisir les informations concernant la compétence à créer", preferredStyle: .alert)
        
        alert.addTextField { (codeTextField) in codeTextField.placeholder = "code compétence" }
        alert.addTextField { (nameTextField) in nameTextField.placeholder = "libellé compétence" }
        alert.addTextField { (levelTextField) in levelTextField.placeholder = "niveau compétence" }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            let code = alert.textFields?[0].text
            let name = alert.textFields?[1].text
            let level = alert.textFields?[2].text
            
            self.SGBD_add_lSkillRessource(code: code!, name: name!, level: level!, idResource: CompetencesViewController.currentResource)
        }))
        
        alert.addAction(UIAlertAction(title: "Liste", style: .default, handler: { (UIAlertAction) in
            self.performSegue(withIdentifier: "segueListeCompetences", sender: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func SGBD_add_lSkillRessource(code: String, name: String, level: String, idResource: String) {
        
        if code != "" && name != "" && level != "" && idResource != "" {
            let referenceTable: DatabaseReference = DataService.dataService.L_SKILLS_RESSOURCES
            
            //let key = referenceTable.childByAutoId().key
            let AAjouter = ["id": code, "name": name, "level": level, "idResource": idResource]
            referenceTable.child(code).setValue(AAjouter)
        }
    }
}
