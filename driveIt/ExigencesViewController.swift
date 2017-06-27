//
//  ExigencesViewController.swift
//  driveIt
//
//  Created by utilisateur on 24/06/2017.
//  Copyright © 2017 SVInfo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ExigencesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewExigence: UITableView!
    
    var exigences = [Requirement]()
    static var currentProject: String!
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let referenceTable = DataService.dataService.REQUIREMENTS.queryOrdered(byChild: "idProject").queryEqual(toValue: ExigencesViewController.currentProject)
        
        referenceTable.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.exigences.removeAll()
                
                for exigence in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let exigenceObjet = exigence.value as? [String: AnyObject]
                    
                    let exigenceId = exigenceObjet?["id"]
                    let exigenceName = exigenceObjet?["name"]
                    let exigenceIdProject = exigenceObjet?["idProject"]
                    
                    let currentExigence = Requirement(id: exigenceId as? String, name: exigenceName as? String, idProject: exigenceIdProject as? String)
                    
                    self.exigences.append(currentExigence)
                }
                
                self.tableViewExigence.reloadData()
            }
        })
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueExigenceTache" {
            let ExigenceTransmise: Requirement = sender as! Requirement
            TachesViewController.currentExigence = ExigenceTransmise.id
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exigences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let currentExigence: Requirement
        currentExigence = exigences[indexPath.row]
        
        Cell.textLabel?.text = currentExigence.name
        return Cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentExigence: Requirement = exigences[indexPath.row]
        performSegue(withIdentifier: "segueExigenceTache", sender: currentExigence)
    }
    
    @IBAction func AddTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Ajouter une exigence", message: "Merci de saisir les informations concernant l'exigence à créer", preferredStyle: .alert)
        
        alert.addTextField { (codeTextField) in codeTextField.placeholder = "code exigence" }
        alert.addTextField { (nameTextField) in nameTextField.placeholder = "libellé exigence" }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            let code = alert.textFields?[0].text
            let name = alert.textFields?[1].text
            
            self.SGBD_add_requirement(code: code!, name: name!, idProject: ExigencesViewController.currentProject)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func SGBD_add_requirement(code: String, name: String, idProject: String) {
        
        if code != "" && name != "" {
            let referenceTable: DatabaseReference = DataService.dataService.REQUIREMENTS
            
            //let key = referenceTable.childByAutoId().key
            let AAjouter = ["id": code, "name": name, "idProject": idProject]
            referenceTable.child(code).setValue(AAjouter)
        }
    }
}
