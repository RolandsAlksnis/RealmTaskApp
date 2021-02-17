//
//  Task.swift
//  RealmTaskApp
//
//  Created by rolands.alksins on 17/02/2021.
//

import Foundation
import RealmSwift


class Task: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var note = ""
    @objc dynamic var date = Date()
    @objc dynamic var isComplete = false
    
}
