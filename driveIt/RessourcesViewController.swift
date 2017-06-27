//
//  RessourcesViewController.swift
//  driveIt
//
//  Created by utilisateur on 25/06/2017.
//  Copyright © 2017 SVInfo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RessourcesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var ressources = [Resource]()
    
    @IBOutlet weak var tableViewResource: UITableView!
   
    override var prefersStatusBarHidden: Bool { return true }
    
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
                
                self.tableViewResource.reloadData()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ressources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let currentRessource: Resource = ressources[indexPath.row]
        
        Cell.textLabel?.text = currentRessource.id
        return Cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentRessource: Resource = ressources[indexPath.row]
        performSegue(withIdentifier: "segueRessourceCompetence", sender: currentRessource)
    }
    
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
