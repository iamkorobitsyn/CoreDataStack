//
//  ViewController.swift
//  CoreDataStack
//
//  Created by Александр Коробицын on 10.11.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        StorageManager.instance.fetchController.delegate = self
        StorageManager.instance.fetch()
        
        setupNavigation()
        setupTableView()
    }
    
//MARK: - UITableView
    
    private func setupTableView() {
        tableView.frame = UIScreen.main.bounds
        tableView.backgroundColor = UIColor.blue.withAlphaComponent(0.1)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }

//MARK: - NavigationBar

    private func setupNavigation() {
        title = "CORE DATA"
        let bar = navigationController?.navigationBar
        
        let appearence: UINavigationBarAppearance = {
            let appearence = UINavigationBarAppearance()
            appearence.backgroundColor = UIColor.green.withAlphaComponent(0.2)
            appearence.titleTextAttributes = [.foregroundColor: UIColor.label]
            appearence.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
            return appearence
        }()
        
        bar?.prefersLargeTitles = true
        bar?.standardAppearance = appearence
        bar?.scrollEdgeAppearance = appearence
        bar?.tintColor = UIColor.label
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .done, target: self, action: #selector(tap))
    }
    
    @objc private func tap() {
        let alert = AlertController(title: "Core Data", message: nil, preferredStyle: .alert)
        present(alert, animated: true)
        alert.completion = { name, age in
            StorageManager.instance.SaveObjTest(name: name, age: age, completion: { result in
            })
        }
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        StorageManager.instance.fetchController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let object = StorageManager.instance.fetchController.object(at: indexPath) as! Testing
        var content = cell.defaultContentConfiguration()
        content.text = ("String  -  \(object.defaultString ?? "")       Int64  -  \(object.defaultNumber)")
        content.textProperties.font = .systemFont(ofSize: 22, weight: .thin)
        cell.contentConfiguration = content
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let test = StorageManager.instance.fetchController.object(at: indexPath) as! Testing
            StorageManager.instance.context.delete(test)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = AlertController(title: "Change", message: nil, preferredStyle: .alert)
        present(alert, animated: true)
        alert.completion = { name, age in
            let test = StorageManager.instance.fetchController.object(at: indexPath) as! Testing
            let cell = self.tableView.cellForRow(at: indexPath)
           
            var content = cell?.defaultContentConfiguration()
            content?.text = ("String  -  \(name )       Int64  -  \(age)")
            content?.textProperties.font = .systemFont(ofSize: 22, weight: .thin)
            cell?.contentConfiguration = content
            
            StorageManager.instance.context.delete(test)
            StorageManager.instance.SaveObjTest(name: name, age: age) { result in
            }
        }
        
    }
}

 //MARK: - Initialization UIAlertController

extension ViewController: NSFetchedResultsControllerDelegate  {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .right)
            }
      default:
            break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

