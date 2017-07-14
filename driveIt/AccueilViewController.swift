//
//  AccueilViewController.swift
//  driveIt
//
//  Created by utilisateur on 20/06/2017.
//  Copyright © 2017 SVInfo. All rights reserved.
//

import UIKit

class AccueilViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var rubriques = ["Projets", "Ressources", "Compétences", "Mes Tâches", "Mes Actions en cours"]
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rubriques.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = rubriques[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            performSegue(withIdentifier: "SegueAccueilProjet", sender: nil)
        case 1:
            performSegue(withIdentifier: "segueAccueilRessource", sender: nil)
        case 2:
            performSegue(withIdentifier: "segueAccueilCompetence", sender: nil)
        default:
            print("choix non valide")
        }
    }
}

