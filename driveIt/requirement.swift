//
//  requirement.swift
//  driveIt
//
//  Created by utilisateur on 24/06/2017.
//  Copyright © 2017 SVInfo. All rights reserved.
//

class Requirement {
    
    var id: String?
    var name: String?
    var idProject: String?
    
    init(id: String?, name: String?, idProject: String?) {
        self.id = id
        self.name = name
        self.idProject = idProject
    }
}
