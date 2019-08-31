//
//  CategoryViewController.swift
//  TodoyCoredata
//
//  Created by IOS User1 on 31/07/19.
//  Copyright © 2019 IOS User1. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
   // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray : Results<Category>?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField : UITextField?
        let alert = UIAlertController(title: "Todoy", message: "AddCategory", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if let textfield = textField
            {
                //print(textfield.text!)
                 let category = Category()
                //print(self.context.hasChanges)
                category.name = textfield.text!
               //self.categoryArray.append(category)
                self.saveData(category: category)
                
            }
            
        }))
        alert.addTextField { (textfield) in
            textField = textfield
        }
        self.present(alert, animated: true, completion: nil)
        
    }
    //MARK:- Data Manipulation methods
    func saveData(category : Category)
    {
        do {
            try realm.write {
                realm.add(category)
            }
            
        }catch{
            print("error saving data\(error)")
        }
        self.tableView.reloadData()
    }
    func loadData() {
        
        categoryArray = realm.objects(Category.self)
        self.tableView.reloadData()
        
        //        let request : NSFetchRequest<Category> = Category.fetchRequest()
        //        do{
        //        categoryArray = try context.fetch(request)
        //        }
        //        catch{
        //            print("error fetching data\(error)")
        //        }
    }


}
extension CategoryViewController{
    
    //MARK:- Tableview DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) 
        cell.textLabel?.text = categoryArray?[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "category", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoyListViewController
        if let indexPath = self.tableView.indexPathForSelectedRow
        {
            destinationVC.selectedCategory = self.categoryArray?[indexPath.row]
        }
    }
}
