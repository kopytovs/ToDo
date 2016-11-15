//
//  TableViewController.swift
//  ToDo
//
//  Created by Sergey Kopytov on 15.11.16.
//  Copyright © 2016 Sergey Kopytov. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var names = [Task]()
    
    let Warn = "Это приложение создано для создания списка ToDo, со временем будет расширятся. Для добавления действия нажать + в правом верхнем углу, для изменения и удаления нажать edit в левом верхнем углу. made by ©Kopytov"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //names = ["fuck", "this", "shit"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
    }
    
    func getData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            names = try context.fetch(Task.fetchRequest())
        }
        catch {
            print ("Fetching error")
        }
    }

    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }*/

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return names.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = names[indexPath.row].name
        
        /*if (self.navigationItem.leftBarButtonItem?.isEnabled)! {
            
        }*/

        return cell
    }
    
    @IBAction func addName(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let task = Task(context: context)

        var loginTextField: UITextField?
        let alertController = UIAlertController(title: "Добавление задачи", message: "введите задачу", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Добавить", style: .default, handler: { (action) -> Void in
            print("Ok Button Pressed")
            let fields = alertController.textFields!
            //self.names.append(fields[0].text!)
            //print("--------------------")
            //print(self.names)
            //print("--------------------")
            task.name = fields[0].text!
            self.names.append(task)
            self.tableView.reloadData()
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        })
        let cancel = UIAlertAction(title: "Отменить", style: .cancel) { (action) -> Void in
            print("Cancel Button Pressed")
        }
        alertController.addAction(ok)
        alertController.addAction(cancel)
        alertController.addTextField { (textField) -> Void in
            // Enter the textfiled customization code here.
            loginTextField = textField
            loginTextField?.placeholder = "Ваша задача"
        }
        //if (ok.isEnabled){
            
            self.tableView.reloadData()
        //}
        
        //tableView.reloadData()
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func infoPush(_ sender: Any) {
        //var loginTextField: UITextField?
        let alertController = UIAlertController(title: "Инфо", message: Warn, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Спасибо!", style: .default, handler: { (action) -> Void in
            print("Ok Button Pressed")
        })
        //let cancel = UIAlertAction(title: "Отменить", style: .cancel) { (action) -> Void in
        //    print("Cancel Button Pressed")
        //}
        alertController.addAction(ok)
        //alertController.addAction(cancel)
        //alertController.addTextField { (textField) -> Void in
            // Enter the textfiled customization code here.
            //loginTextField = textField
            //loginTextField?.placeholder = "Ваша задача"
        //}
        //if (ok.isEnabled){
        
        self.tableView.reloadData()
        //}
        
        //tableView.reloadData()
        present(alertController, animated: true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*func showEditing(sender: UIBarButtonItem)
    {
        if(self.tableView.isEditing == true)
        {
            self.tableView.isEditing = false
            self.navigationItem.leftBarButtonItem?.title = "Done"
            
        }
        else
        {
            self.tableView.isEditing = true
            self.navigationItem.leftBarButtonItem?.title = "Edit"
        }
    }*/
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if editingStyle == .delete {
            // Delete the row from the data source
            let task = names[indexPath.row]
            context.delete(task)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            //names.remove(at: indexPath.row)
            do {
                names = try context.fetch(Task.fetchRequest())
            }
            catch {
                print ("Fetching error")
            }
            //tableView.reloadData()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
