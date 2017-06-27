//
//  ProjetsViewController.swift
//  driveIt
//
//  Created by utilisateur on 20/06/2017.
//  Copyright © 2017 SVInfo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ProjetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewProjects: UITableView!
    //var projets = ["Projet 1", "Projet 2", "Projet 3", "Projet 4"]
    var projets = [Project]()
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let referenceTable: DatabaseReference = DataService.dataService.PROJECTS
        
        referenceTable.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.projets.removeAll()
                
                for projet in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let projetObjet = projet.value as? [String: AnyObject]
                    
                    let projetId = projetObjet?["id"]
                    let projetName = projetObjet?["name"]
                    
                    let currentProjet = Project(id: projetId as? String, name: projetName as? String )
                    
                    self.projets.append(currentProjet)
                }
                
                self.tableViewProjects.reloadData()
            }
        })
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueProjetExigence" {
            let projetTransmis: Project = sender as! Project
            ExigencesViewController.currentProject = projetTransmis.id
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let currentProjet: Project
        currentProjet = projets[indexPath.row]
        
        Cell.textLabel?.text = currentProjet.name
        return Cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentProjet: Project = projets[indexPath.row]
        performSegue(withIdentifier: "segueProjetExigence", sender: currentProjet)
    }

    @IBAction func AddTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Ajouter un projet", message: "Merci de saisir les informations concernant le projet à créer", preferredStyle: .alert)
        
        alert.addTextField { (codeTextField) in codeTextField.placeholder = "code Projet" }
        alert.addTextField { (nameTextField) in nameTextField.placeholder = "libellé Projet" }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            let codeProjet = alert.textFields?[0].text
            let nameProjet = alert.textFields?[1].text
            
            self.SGBD_add_project(code: codeProjet!, name: nameProjet!)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func SGBD_add_project(code: String, name: String) {
        
        if code != "" && name != "" {
            let referenceTable: DatabaseReference = DataService.dataService.PROJECTS
            
            //let key = referenceTable.childByAutoId().key
            let projetAAjouter = ["id": code, "name": name]
            referenceTable.child(code).setValue(projetAAjouter)
        }
    }
}
