//
//  RessourcesTableTableViewController.swift
//  driveIt
//
//  Created by utilisateur on 27/06/2017.
//  Copyright © 2017 SVInfo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RessourcesTableViewController: UITableViewController {

    var ressources = [Resource]()

    @IBOutlet var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let referenceTable = DataService.dataService.RESOURCES
        
        referenceTable.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.ressources.removeAll()
                
                for resource in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let ressourceObjet = resource.value as? [String: AnyObject]
                    
                    let ressourceId = ressourceObjet?["id"]
                    let ressourceNom = ressourceObjet?["nom"]
                    let ressourcePrenom = ressourceObjet?["prenom"]
                    
                    let currentRessource = Resource(id: ressourceId as? String, nom: ressourceNom as? String, prenom: ressourcePrenom as? String)
                    
                    self.ressources.append(currentRessource)
                }
                
                self.myTableView.reloadData()
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
        return ressources.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let currentRessource: Resource = ressources[indexPath.row]
        
        Cell.textLabel?.text = currentRessource.id
        return Cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentRessource: Resource = ressources[indexPath.row]
        performSegue(withIdentifier: "segueRessourceCompetence", sender: currentRessource)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueRessourceCompetence" {
            let RessourceTransmise: Resource = sender as! Resource
            CompetencesViewController.currentResource = RessourceTransmise.id
        }
    }
    
    @IBAction func AddTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Ajouter une ressource", message: "Merci de saisir les informations concernant la ressource à créer", preferredStyle: .alert)
        
        alert.addTextField { (codeTextField) in codeTextField.placeholder = "code ressource" }
        alert.addTextField { (nomTextField) in nomTextField.placeholder = "nom ressource" }
        alert.addTextField { (prenomTextField) in prenomTextField.placeholder = "prenom ressource" }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            let code = alert.textFields?[0].text
            let nom = alert.textFields?[1].text
            let prenom = alert.textFields?[2].text
            
            self.SGBD_add_resource(code: code!, nom: nom!, prenom: prenom!)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func SGBD_add_resource(code: String, nom: String, prenom: String) {
        
        if code != "" && nom != "" && prenom != "" {
            let referenceTable: DatabaseReference = DataService.dataService.RESOURCES
            
            let AAjouter = ["id": code, "nom": nom, "prenom": prenom]
            referenceTable.child(code).setValue(AAjouter)
        }
    }
 

}
