//
//  IndividualTaskTableViewController.swift
//  RealmTaskApp
//
//  Created by rolands.alksins on 17/02/2021.
//

import UIKit
import RealmSwift

class IndividualTaskTableViewController: UITableViewController {

    var currentTasksList: TasksList!
    var currentTask: Results<Task>!
    var completedTask: Results<Task>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = currentTasksList.name
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    @IBAction func addItemTapped(_ sender: Any) {
        alertForAppUpdateList()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Current Tasks" : "Completed Tasks"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return section == 0 ? currentTask.count : completedTask.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tasksCell", for: indexPath)

        var task: Task!
        // section
        task = indexPath.section == 0 ? currentTask[indexPath.row] : completedTask[indexPath.row]

        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.note
        cell.selectionStyle = .none
        
        return cell
    }
    
// MARK: - TABLE VIEW DELEGATE
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var task: Task!
        task = indexPath.section == 0 ? currentTask[indexPath.row] : completedTask[indexPath.row]

        
        let contextItemDelete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            StorageManager.deleteTask(task)
            self.filteringTasks()
        }
        
        let contextItemEdit = UIContextualAction(style: .destructive, title: "Edit") { (_, _, _) in
            self.alertForAppUpdateList(task)
            self.filteringTasks()
        }
        
        let contextItemDone = UIContextualAction(style: .destructive, title: "Done") { (_, _, _) in
            StorageManager.makeAllDone(task)
            self.filteringTasks()
        }
        
        contextItemEdit.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        contextItemDone.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        let swipeAction = UISwipeActionsConfiguration(actions: [contextItemDelete, contextItemEdit, contextItemDone])
        
        return swipeAction
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

    private func filteringTasks() {
        currentTask = currentTasksList.tasks.filter("isComplete = false")
        completedTask = currentTasksList.tasks.filter("isComplete = true")
        tableView.reloadData()
    }
    
}

extension IndividualTaskTableViewController{
    
    private func alertForAppUpdateList(_ taskName: Task? = nil) {
            
        var title = "New Task"
        var doneButton = "Save"
        
        if taskName != nil {
            title = "Edit Task"
            doneButton = "Update"
        }
        
        let alert = UIAlertController(title: title, message: "Please insert new task", preferredStyle: .alert)
        
        var taskTextField: UITextField!
        var noteTextField: UITextField!
        
        let saveAction = UIAlertAction(title: doneButton, style: .default) { (_) in
            guard let newTask = taskTextField.text, !newTask.isEmpty else { return }
            
            if let taskName = taskName {
                if let newNote = noteTextField.text, !newTask.isEmpty {
                    StorageManager.editTask(taskName, newTask: newTask, newNote: newNote)
                } else {
                    StorageManager.editTask(taskName, newTask: newTask, newNote: "")
                }
                // filter
                self.filteringTasks()
            } else {
                let task = Task()
                task.name = newTask
                
                if let note = noteTextField.text, !note.isEmpty {
                    task.name = note
                }
                
                StorageManager.saveTask(self.currentTasksList, task: task)
                self.filteringTasks()
            }
            
        }// save
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { (textField) in
            taskTextField = textField
            taskTextField.placeholder = "New Task"
        
        
        if let taskName = taskName {
            taskTextField.text = taskName.name
            }
        }
        
        alert.addTextField { (textField) in
            noteTextField = textField
            taskTextField.placeholder = "Note"
            
            if let taskName = taskName {
                taskTextField.text = taskName.note
            }
        }
        
        present(alert, animated: true)
        
    }//func
    
    
    
}//extension
