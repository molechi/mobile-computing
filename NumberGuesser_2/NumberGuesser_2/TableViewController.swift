//
//  TableViewController.swift
//  NumberGuesser_2
//
//  Created by Moritz Lechthaler on 16.12.21.
//

import UIKit

class TableViewController: UITableViewController {
    let queue = DispatchQueue(label: "download")
    let path = "https://jsonplaceholder.typicode.com/todos"
    var model = ToDoModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: path){
            queue.async {
                let todo = self.download(url: url)
                DispatchQueue.main.async {
                    self.model.todos = todo
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.todos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        UITableViewCell{
            let cell = tableView.dequeueReusableCell(withIdentifier: "todo", for: indexPath)
            let todo = model.[indexPath.row]
            cell.textLabel?.text = todo.titel
            cell.detailTextLabel
            
        }
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
    
    func download(url: URL) -> [ToDo] {
        print("downloading \(url)")
        var todos = [ToDo]()
        if let data = try? Data(contentsOf: url){
        print("data is \(data)")
            let obj = try? JSONSerialization.jsonObject(with: data, options: [])
            if let array = obj as? [[String: Any]] {
                for el in array {
                    let todo = ToDo()
                    if let id = el ["id"] as? Int, let titel = el ["titel"] as? String{
                        todo.id = id
                        todo.titel = titel
                        todos.append(todo)
                        print("id: \(id), titel: \(titel)")
                    }
                    
                }
             //   print("data is \(array)")
            }
           // print("data is \(obj)")
        }else{
            print("ka download")
        }
        return todos
    }

}
