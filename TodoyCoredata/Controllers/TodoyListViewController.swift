//
//  TodoyListViewController.swift
//  TodoyCoredata
//
//  Created by IOS User1 on 30/07/19.
//  Copyright © 2019 IOS User1. All rights reserved.
//

import UIKit
import RealmSwift

class TodoyListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var todoItems : Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category?
  

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//        print(context.hasChanges)
        // Do any additional setup after loading the view.
        if let selectedcat = selectedCategory
        {
            loadItems()
        }
  
    }
    

    @IBAction func addButtonAction(_ sender: Any) {
        var textField : UITextField?
       let alert = UIAlertController(title: "Todoy", message: "AddTodoItems", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if let textfield = textField
            {
               // print(textfield.text!)
                if let currentCategory = self.selectedCategory
                {

                    do
                    {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textfield.text!
                            newItem.done = false
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    }catch{
                        print("error saving data to realm\(error)")
                    }
                    self.loadItems()
                }
          
                
            }
            
        }))
        alert.addTextField { (textfield) in
            textField = textfield
        }
        self.present(alert, animated: true, completion: nil)
        
    }

    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: false)
        self.tableview.reloadData()

    }

}

extension TodoyListViewController : UITableViewDataSource , UITableViewDelegate , UISearchBarDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let item = todoItems?[indexPath.row]
        {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else
        {
            cell.textLabel?.text = "No items Added"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if let item = todoItems?[indexPath.row]
         {
            do{
                try realm.write {
                    //delete object from realm
                   // realm.delete(item)
                    
                    //updating data in realm
                    item.done = !item.done
                    
                }
            }
            catch
            {
                print("error updating done property\(error)")
            }
        }
        tableview.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK:- SearchBar Delegates
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
   
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        todoItems = todoItems?.filter(predicate).sorted(byKeyPath: "title", ascending: true)
        //check nspredicate cheatsheet for detailed understanding on nspredicates
        tableview.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
               searchBar.resignFirstResponder()
            }

        }
    }
}

