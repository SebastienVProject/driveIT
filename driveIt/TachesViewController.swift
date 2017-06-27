//
//  TachesViewController.swift
//  driveIt
//
//  Created by utilisateur on 24/06/2017.
//  Copyright © 2017 SVInfo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class TachesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var taches = [Task]()
    static var currentExigence: String!
    
    @IBOutlet weak var tableViewTache: UITableView!
    
    override var prefersStatusBarHidden: Bool { return true }

    override func viewDidLoad() {
        super.viewDidLoad()

        let referenceTable = DataService.dataService.TASKS.queryOrdered(byChild: "idRequirement").queryEqual(toValue: TachesViewController.currentExigence)
        
        referenceTable.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.taches.removeAll()
                
                for tache in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let tacheObjet = tache.value as? [String: AnyObject]
                    
                    let tacheId = tacheObjet?["id"]
                    let tacheName = tacheObjet?["name"]
                    let tacheIdRequirement = tacheObjet?["idRequirement"]
                    
                    let currentTache = Task(id: tacheId as? String, name: tacheName as? String, idRequirement: tacheIdRequirement as? String)
                    
                    self.taches.append(currentTache)
                }
                
                self.tableViewTache.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let currentTache: Task = taches[indexPath.row]
        
        Cell.textLabel?.text = currentTache.name
        return Cell
    }
    
    @IBAction func AddTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Ajouter une tache", message: "Merci de saisir les informations concernant la tache à créer", preferredStyle: .alert)
        
        alert.addTextField { (codeTextField) in codeTextField.placeholder = "code tache" }
        alert.addTextField { (nameTextField) in nameTextField.placeholder = "libellé tache" }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            let code = alert.textFields?[0].text
            let name = alert.textFields?[1].text
            
            self.SGBD_add_task(code: code!, name: name!, idRequirement: TachesViewController.currentExigence)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func SGBD_add_task(code: String, name: String, idRequirement: String) {
        
        if code != "" && name != "" {
            let referenceTable: DatabaseReference = DataService.dataService.TASKS
            
            //let key = referenceTable.childByAutoId().key
            let AAjouter = ["id": code, "name": name, "idRequirement": idRequirement]
            referenceTable.child(code).setValue(AAjouter)
        }
    }
}
