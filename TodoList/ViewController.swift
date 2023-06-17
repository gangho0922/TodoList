//
//  ViewController.swift
//  TodoList
//
//  Created by AnnKangHo on 2023/06/14.
//

import UIKit
import CoreData
import SnapKit

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
        getAllItems()
        title = "My To Do"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "새로 입력", message: "넣을 것을 입력해주세요.", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            self?.createItem(name: text)
        }))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = models[indexPath.row]
        let sheet = UIAlertController(title: "수정", message: "수정할 것을 입력해주세요.", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "수정", style: .default, handler: { _ in
            let alert = UIAlertController(title: "수정", message: "수정할 것을 입력해주세요.", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.sentence
            alert.addAction(UIAlertAction(title: "저장", style: .cancel, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let newSentence = field.text, !newSentence.isEmpty else {
                    return
                }
                self?.updateItem(item: item, newSentence: newSentence)
            }))
            self.present(alert, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
            self?.deleteItem(item: item)
        }))
        present(sheet, animated: true)
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
            getAllItems()
        } catch {
            
        }
    }
    func deleteItem(item: ListContents) {
        context.delete(item)
        do {
            try context.save()
            getAllItems()
        } catch {
            
        }
    }
    func updateItem(item: ListContents, newSentence: String) {
        item.sentence = newSentence
        do {
            try context.save()
            getAllItems()
        } catch {
            
        }
    }
}
    
