//
//  dataSource.swift
//  driveIt
//
//  Created by utilisateur on 24/06/2017.
//  Copyright © 2017 SVInfo. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DataService {
    static let dataService = DataService()
    
    private var _BASE_REF = Database.database().reference()
    private var _PROJECTS = Database.database().reference().child("projects")
    private var _REQUIREMENTS = Database.database().reference().child("requirements")
    private var _TASKS = Database.database().reference().child("tasks")
    private var _RESOURCES = Database.database().reference().child("resources")
    private var _SKILLS = Database.database().reference().child("skills")
    private var _L_SKILLS_RESSOURCES = Database.database().reference().child("link_skills_ressources")
    
    var BASE_REF: DatabaseReference {
        return _BASE_REF
    }
    
    var PROJECTS: DatabaseReference {
        return _PROJECTS
    }

    var REQUIREMENTS: DatabaseReference {
        return _REQUIREMENTS
    }

    var TASKS: DatabaseReference {
        return _TASKS
    }

    var RESOURCES: DatabaseReference {
        return _RESOURCES
    }

    var SKILLS: DatabaseReference {
        return _SKILLS
    }

    var L_SKILLS_RESSOURCES: DatabaseReference {
        return _L_SKILLS_RESSOURCES
    }
}

