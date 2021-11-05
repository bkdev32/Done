//
//  CategoryViewController.swift
//  Done
//
//  Created by Burhan Kaynak on 28/01/2021.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        tableView.backgroundColor = FlatNavyBlue()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation Controller cannot be loaded")
        }
        let navBarAppearance = UINavigationBarAppearance()
        navBar.backgroundColor = UIColor(named: "PrimaryColor")
        navBarAppearance.backgroundColor = UIColor(named: "PrimaryColor")
        navBarAppearance.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : ContrastColorOf(navBar.backgroundColor!, returnFlat: true)]
        navBar.standardAppearance = navBarAppearance
        navBar.scrollEdgeAppearance = navBarAppearance
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Create a new list", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Create", style: .default) { (action) in
            let newCategory = Category()
            if textField.text == "" {
                self.presentAlert(message: "You have not added any new list")
            } else {
                newCategory.title = textField.text!
                newCategory.date = Date()
                let randomColor = RandomFlatColor().hexValue()
                newCategory.color = randomColor
                self.save(newCategory)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new list"
            textField = alertTextField
        }
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.title
            cell.backgroundColor = UIColor(hexString: category.color)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toItemsVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemsViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    func save(_ newCategory: Category) {
        do {
            try realm.write {
                realm.add(newCategory)
            }
        } catch {
            print("Unable to save data \(error.localizedDescription)")
            presentAlert(message: error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func load() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryToDelete = self.categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryToDelete)
                }
            } catch {
                print("Error deleting the category \(error.localizedDescription)")
                presentAlert(message: error.localizedDescription)
            }
        }
    }
}
