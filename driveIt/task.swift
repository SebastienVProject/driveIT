//
//  requirement.swift
//  driveIt
//
//  Created by utilisateur on 24/06/2017.
//  Copyright © 2017 SVInfo. All rights reserved.
//
import FirebaseDatabase

class Task {
    
    var id: String?
    var name: String?
    var idRequirement: String?
    var idRessource: String?
    var status: String?
    var dateCreation: String?
    var dateAffectation: String?
    
    init(id: String?, name: String?, idRequirement: String?, idRessource: String?, status: String?, dateCreation: String?, dateAffectation: String?) {
        self.id = id
        self.name = name
        self.idRequirement = idRequirement
        self.idRessource = idRessource
        self.status = status
        self.dateCreation = dateCreation
        self.dateAffectation = dateAffectation
    }
    
    func update(idTask: String, idRequirement: String? = nil, name: String? = nil, idRessource: String? = nil, status: String? = nil, dateCreation: String? = nil, dateAffectation: String? = nil) {
        
        let idRequirementValue = (idRequirement == nil) ? self.idRequirement: idRequirement
        let nameValue = (name == nil) ? self.name: name
        let idRessourceValue = (idRessource == nil) ? self.idRessource: idRessource
        let statusValue = (status == nil) ? self.status: status
        let dateCreationValue = (dateCreation == nil) ? self.dateCreation: dateCreation
        let dateAffectationValue = (dateAffectation == nil) ? self.dateAffectation: dateAffectation
        
        if idTask != "" {
            let referenceTable: DatabaseReference = DataService.dataService.TASKS
            
            let element = ["id": idTask, "idRequirement": idRequirementValue, "name": nameValue, "idRessource": idRessourceValue, "status": statusValue, "dateCreation": dateCreationValue, "dateAffectation": dateAffectationValue]
            referenceTable.child(idTask).setValue(element)
        }
    }
    static func insert(idTask: String, idRequirement: String? = nil, name: String? = nil, idRessource: String? = nil, status: String? = nil, dateCreation: String? = nil, dateAffectation: String? = nil) {
        
        if idTask != "" {
            let referenceTable: DatabaseReference = DataService.dataService.TASKS
            
            let element = ["id": idTask, "idRequirement": idRequirement, "name": name, "idRessource": idRessource, "status": status, "dateCreation": dateCreation, "dateAffectation": dateAffectation]
            referenceTable.child(idTask).setValue(element)
        }
    }
}
