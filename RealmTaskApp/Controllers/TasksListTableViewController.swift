//
//  TasksListTableViewController.swift
//  RealmTaskApp
//
//  Created by rolands.alksins on 17/02/2021.
//

import UIKit
import RealmSwift

class TasksListTableViewController: UITableViewController {

    var tasksList: Results<TasksList>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tasksList = realm.objects(TasksList.self)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    @IBAction func editItemTapped(_ sender: Any) {
    }
    @IBAction func addNewItemTapped(_ sender: Any) {
        alertForAppUpdateList()
    }
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasksList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tasksListCell", for: indexPath)

        let taskList = tasksList[indexPath.row]
        //cell.textLabel?.text = taskList.name

        cell.configure(with: taskList)
        cell.selectionStyle = .none
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UITableViewCell {
    
    func configure(with tasksLists: TasksList) {
        let currentTasks = tasksLists.tasks.filter("isComplete = false")
        let completedTasks = tasksLists.tasks.filter("isComplete = ture")
        
        textLabel?.text = tasksLists.name
        
        if !currentTasks.isEmpty {
            detailTextLabel?.text = "\(currentTasks.count)"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 20)
            detailTextLabel?.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        } else if !completedTasks.isEmpty {
            detailTextLabel?.text = "✅"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 30)
            detailTextLabel?.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        } else {
            detailTextLabel?.text = "0"
        }
        
        
    }
    
    
}



extension TasksListTableViewController{
    
    private func alertForAppUpdateList(_ listName: TasksList? = nil, completion: (() -> Void)? = nil) {
            
        var title = "New List"
        var doneButton = "Save"
        
        if listName != nil {
            title = "Edit List"
            doneButton = "Update"
        }
        
        let alert = UIAlertController(title: title, message: "Please insert new value", preferredStyle: .alert)
        
        var alertTextField: UITextField!
        
        let saveAction = UIAlertAction(title: doneButton, style: .default) { (_) in
            guard let newList = alertTextField.text, !newList.isEmpty else { return }
            
            if let listName = listName {
                StorageManager.editList(listName, newListName: newList)
                if completion != nil { completion!() }
            } else {
                let  taskList = TasksList()
                taskList.name = newList
                
                StorageManager.saveTasksList(taskList)
                self.tableView.insertRows(at: [IndexPath(row: self.tasksList.count - 1, section: 0)], with: .automatic)
            }
            
        }// save
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { (textField) in
            alertTextField = textField
            alertTextField.placeholder = "List Name"
        }
        
        if let listName = listName {
            alertTextField.text = listName.name
        }
        
        present(alert, animated: true)
        
        
    }//func
    
    
    
}//extension
