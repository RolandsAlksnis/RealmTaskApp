//
//  StorageManager.swift
//  RealmTaskApp
//
//  Created by rolands.alksins on 17/02/2021.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    
    // MARK: - TASKS LIST METHODS
    
    static func saveTasksList(_ tasksList: TasksList) {
        try! realm.write {
            realm.add(tasksList)
        }
    }
    
    
    static func deleteList(_ tasksList: TasksList) {
        try! realm.write {
            let tasks = tasksList.tasks
            realm.delete(tasks)
            realm.delete(tasksList)
        }
    }
    
    
    static func editList(_ tasksList: TasksList, newListName: String) {
        try! realm.write {
            tasksList.name = newListName
        }
    }
    
    
    static func makeAllDone(_ tasksList: TasksList) {
        try! realm.write {
            tasksList.tasks.setValue(true, forKey: "isComplete")
        }
    }
    
    // MARK: - INDIVIDUAL TASK METHODS
    
    static func saveTask(_ tasksList: TasksList, task: Task) {
        try! realm.write {
            tasksList.tasks.append(task)
        }
    }
    
    
    static func editTask(_ task: Task, newTask: String, newNote: String) {
        try! realm.write {
            task.name = newTask
            task.note = newNote
        }
    }
    
    
    static func deleteTask(_ task: Task) {
        try! realm.write {
            realm.delete(task)
        }
    }
    
    static func makeAllDone(_ task: Task) {
        try! realm.write {
            task.isComplete.toggle()
        }
    }
    
    
}
