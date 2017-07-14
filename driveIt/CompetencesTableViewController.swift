//
//  CompetencesTableViewController.swift
//  driveIt
//
//  Created by utilisateur on 09/07/2017.
//  Copyright © 2017 SVInfo. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CompetencesTableViewController: UITableViewController {

    var competences = [LSkillRessource]()

    static var currentResource: String!
    
    override var prefersStatusBarHidden: Bool { return true }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return competences.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CompetencesTableViewCell
        
        let currentCompetence: LSkillRessource = competences[indexPath.row]
        
        Cell.libelleLabel?.text = currentCompetence.name
        Cell.levelLabel?.text = currentCompetence.level
        return Cell
    }
    
    @IBAction func AddTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Ajouter une compétence", message: "Merci de saisir les informations concernant la compétence à créer", preferredStyle: .alert)
        
        alert.addTextField { (codeTextField) in codeTextField.placeholder = "code compétence" }
        alert.addTextField { (nameTextField) in nameTextField.placeholder = "libellé compétence" }
        alert.addTextField { (levelTextField) in levelTextField.placeholder = "niveau compétence" }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            let code = alert.textFields?[0].text
            let name = alert.textFields?[1].text
            let level = alert.textFields?[2].text
            
            self.SGBD_add_lSkillRessource(code: code!, name: name!, level: level!, idResource: CompetencesTableViewController.currentResource)

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
            let AAjouter = ["id": code, "name": name, "level": level, "idResource": idResource] as [String : Any]
            referenceTable.child(code).setValue(AAjouter)
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
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
