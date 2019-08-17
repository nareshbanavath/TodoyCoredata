//
//  CategoryViewController.swift
//  TodoyCoredata
//
//  Created by IOS User1 on 31/07/19.
//  Copyright © 2019 IOS User1. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray = [Category]()
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
                let category = Category(context: self.context)
                //print(self.context.hasChanges)
                category.name = textfield.text!
                self.categoryArray.append(category)
                self.saveData()
                
            }
            
        }))
        alert.addTextField { (textfield) in
            textField = textfield
        }
        self.present(alert, animated: true, completion: nil)
        
    }
    //MARK:- Data Manipulation methods
    func saveData()
    {
        do {
            try context.save()
            
        }catch{
            print("error saving data\(error)")
        }
        self.tableView.reloadData()
    }
    func loadData() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
        categoryArray = try context.fetch(request)
        }
        catch{
            print("error fetching data\(error)")
        }
        self.tableView.reloadData()
    }


}
extension CategoryViewController{
    
    //MARK:- Tableview DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) 
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "category", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoyListViewController
        if let indexPath = self.tableView.indexPathForSelectedRow
        {
            destinationVC.selectedCategory = self.categoryArray[indexPath.row]
        }
    }
}
