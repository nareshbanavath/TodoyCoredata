//
//  TodoyListViewController.swift
//  TodoyCoredata
//
//  Created by IOS User1 on 30/07/19.
//  Copyright © 2019 IOS User1. All rights reserved.
//

import UIKit
import CoreData

class TodoyListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    var selectedCategory : Category?


    override func viewDidLoad() {
        super.viewDidLoad()
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
                print(textfield.text!)
                let item = Item(context: self.context)
                print(self.context.hasChanges)
                item.title = textfield.text!
                item.parentCategory = self.selectedCategory
                item.done = false
                self.itemArray.append(item)
                self.saveData()
                
            }
            
        }))
        alert.addTextField { (textfield) in
            textField = textfield
        }
        self.present(alert, animated: true, completion: nil)
        
    }
    func saveData()  {
        do{
           try context.save()
        }catch
        {
            print("Error saving context\(error)")
        }
        self.tableview.reloadData()
    }
    //MARK: - Load Items
    //here in this func 'with' is external parameter(appears when we call function) and 'request' is internal parameter(used inside the fuction) we write func like this to avoid confusion
    //here we can give default value for function parameter (** means if you call function without arguments it takes default value)
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()) {
        
        //preparing request object to fetch data from persistent container
        //here giving type to request is mandotary (let reuest = Item.fetchRequest() gives you 'ambiguos error')
       let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        request.predicate = predicate
        do{
           itemArray = try context.fetch(request)
        }
        catch {
            print("error fetching data \(error)")
        }
        
        self.tableview.reloadData()
      
    }

}

extension TodoyListViewController : UITableViewDataSource , UITableViewDelegate , UISearchBarDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        /*  itemArray.remove(at: indexPath.row)
         context.delete(itemArray[indexPath.row]) */
        // if we write like above then it throws indexOutOfBounds error becz first we removing element from array and trying to access removed object of array.
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK:- SearchBar Delegates
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //check nspredicate cheatsheet for detailed understanding on nspredicates
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request)
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
