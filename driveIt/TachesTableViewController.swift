//
//  TachesTableViewController.swift
//  driveIt
//
//  Created by utilisateur on 14/07/2017.
//  Copyright © 2017 SVInfo. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TachesTableViewController: UITableViewController {

    var taches = [Task]()
    static var currentExigence: String!
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let referenceTable = DataService.dataService.TASKS.queryOrdered(byChild: "idRequirement").queryEqual(toValue: TachesTableViewController.currentExigence)
        
        referenceTable.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.taches.removeAll()
                
                for tache in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let tacheObjet = tache.value as? [String: AnyObject]
                    
                    let tacheId = tacheObjet?["id"]
                    let tacheName = tacheObjet?["name"]
                    let tacheIdRequirement = tacheObjet?["idRequirement"]
                    let tacheIdRessource = tacheObjet?["idRessource"]
                    let tacheStatus = tacheObjet?["status"]
                    let tachedateCreation = tacheObjet?["dateCreation"]
                    let tachedateAffectation = tacheObjet?["dateAffectation"]
                    
                    let currentTache = Task(id: tacheId as? String, name: tacheName as? String, idRequirement: tacheIdRequirement as? String, idRessource: tacheIdRessource as? String ,status: tacheStatus as? String, dateCreation: tachedateCreation as? String, dateAffectation: tachedateAffectation as? String)
                    
                    self.taches.append(currentTache)
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taches.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TachesTableViewCell
        
        let currentTache: Task = taches[indexPath.row]
        
        Cell.nomLabel.text = currentTache.name
        Cell.statusLabel.text = currentTache.status
        return Cell
    }

    @IBAction func AddTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Ajouter une tache", message: "Merci de saisir les informations concernant la tache à créer", preferredStyle: .alert)
        
        alert.addTextField { (codeTextField) in codeTextField.placeholder = "code tache" }
        alert.addTextField { (nameTextField) in nameTextField.placeholder = "libellé tache" }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            let code = alert.textFields?[0].text
            let name = alert.textFields?[1].text
            
            Task.insert(idTask: code!, idRequirement: TachesTableViewController.currentExigence, name: name, status: "N", dateCreation: String(describing: Date()))
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func SGBD_add_task(code: String, name: String, idRequirement: String) {
        
        if code != "" && name != "" {
            let referenceTable: DatabaseReference = DataService.dataService.TASKS
            
            //let key = referenceTable.childByAutoId().key
            let AAjouter = ["id": code, "name": name, "idRequirement": idRequirement, "status": "N"]
            referenceTable.child(code).setValue(AAjouter)
        }
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var actions = [UITableViewRowAction]()
        
        if (taches[indexPath.row].status == "N") {
            let AffectationAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Me l'affecter", handler: { (action, indexPath) -> Void in
                
                self.taches[indexPath.row].update(idTask: self.taches[indexPath.row].id!, idRessource: LoginEmailViewController.currentUser, status: "A", dateAffectation: String(describing: Date()))
                self.tableView.reloadData()
                
            })
            AffectationAction.backgroundColor = UIColor(red: 48.0/255.0, green: 173.0/255.0, blue: 99.0/255.0, alpha: 1.0)
            
            actions.append(AffectationAction)
        }
        if (taches[indexPath.row].status == "A") {
            let AbandonAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Annuler", handler: { (action, indexPath) -> Void in
                
                self.taches[indexPath.row].update(idTask: self.taches[indexPath.row].id!, status: "N")
                self.tableView.reloadData()
                
            })
            AbandonAction.backgroundColor = UIColor.red
            
            actions.append(AbandonAction)

            let TerminerAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Terminer", handler: { (action, indexPath) -> Void in
                
                self.taches[indexPath.row].update(idTask: self.taches[indexPath.row].id!, status: "OK")
                self.tableView.reloadData()
                
            })
            TerminerAction.backgroundColor = UIColor(red: 48.0/255.0, green: 173.0/255.0, blue: 99.0/255.0, alpha: 1.0)
            
            actions.append(TerminerAction)
}
        
        return actions
    }

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
