//
//  ViewController.swift
//  TodoList
//
//  Created by AnnKangHo on 2023/06/14.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var models = [ListContents]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My To Do"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        //navigationItem.rightBarButtonItem = UIbar
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.sentence
        return cell
    }
    func getAllItems() {
        do {
            models = try context.fetch(ListContents.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            
        }
        
    }
    func createItem(name: String) {
        let newItem = ListContents(context: context)
        newItem.dates = Date()
        newItem.sentence = name
        do {
            try context.save()
            
        } catch {
            
        }
    }
    func deleteItem(item: ListContents) {
        context.delete(item)
        do {
            try context.save()
            
        } catch {
            
        }
    }
    func updateItem(item: ListContents, newSentence: String) {
        item.sentence = newSentence
        do {
            try context.save()
            
        } catch {
            
        }
    }
}
    
