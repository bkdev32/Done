//
//  ListViewController.swift
//  Done
//
//  Created by Burhan Kaynak on 28/01/2021.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ItemsViewController: SwipeTableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    var items: Results<Item>?
    var selectedCategory: Category? {didSet{ load() }}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        searchBar.delegate = self
        tableView.backgroundColor = FlatNavyBlue()
        if let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField,
           let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = UIColor(named: "SearchColor")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let categoryColor = selectedCategory?.color {
            navigationItem.title = selectedCategory?.title
            guard let navBar = navigationController?.navigationBar else {
                fatalError("Navigation Controller cannot be loaded")
            }
            let navBarAppearance = UINavigationBarAppearance()
            if let navBarColour = UIColor(hexString: categoryColor) {
                navBar.backgroundColor = navBarColour
                navBarAppearance.backgroundColor = navBarColour
                navBar.largeTitleTextAttributes = [
                    NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
                navBarAppearance.largeTitleTextAttributes = [
                    NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
                searchBar.barTintColor = navBarColour
                searchBar.searchTextField.backgroundColor = .white
                searchBar.searchTextField.textColor = UIColor(named: "SearchColor")
            }
            navBar.standardAppearance = navBarAppearance
            navBar.scrollEdgeAppearance = navBarAppearance
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.date = Date()
                        newItem.done = false
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Unable to save data \(error.localizedDescription)")
                    self.presentAlert(message: error.localizedDescription)
                }
                self.tableView.reloadData()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            if let cellColour = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count)) {
                cell.backgroundColor = cellColour
            }
        } else {
            cell.textLabel?.text = "No items found"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Unable to complete the action \(error)")
                presentAlert(message: error.localizedDescription)
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func load() {
        items = selectedCategory?.items.sorted(byKeyPath: "date", ascending: false)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemToDelete = self.items?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemToDelete)
                }
            } catch {
                print("Unable to delete the item \(error.localizedDescription)")
                presentAlert(message: error.localizedDescription)
            }
        }
    }
}

extension ItemsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: false)
        tableView.reloadData()
        if searchBar.text == "" {
            load()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            load()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
