//
//  requirement.swift
//  driveIt
//
//  Created by utilisateur on 24/06/2017.
//  Copyright © 2017 SVInfo. All rights reserved.
//

class Task {
    
    var id: String?
    var name: String?
    var idRequirement: String?
    var status: String?
    
    init(id: String?, name: String?, idRequirement: String?, status: String?) {
        self.id = id
        self.name = name
        self.idRequirement = idRequirement
        self.status = status
    }
}
