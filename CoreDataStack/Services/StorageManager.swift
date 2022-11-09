//
//  StorageManager.swift
//  CoreDataStack
//
//  Created by Александр Коробицын on 10.11.2022.
//

import Foundation
import CoreData

class StorageManager {
    
    //MARK: - Public methods
    
    static let instance = StorageManager()
    let context: NSManagedObjectContext
    let fetchController: NSFetchedResultsController<NSFetchRequestResult>
    
    private init() {
        context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Testing")
        
        
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                     managedObjectContext: context,
                                                     sectionNameKeyPath: nil,
                                                     cacheName: nil)
    }
    
    func fetch() {
        do {
            try StorageManager.instance.fetchController.performFetch()
        } catch {
            print(error)
        }
    }

    func SaveObjTest(name: String, age: Int64, completion: (Testing) -> Void) {
        let object = Testing(context: context)
        object.defaultString = name
        object.defaultNumber = age
        object.date = .now
        saveContext()
        completion(object)
    }
   
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: - Private methods
    
    private var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "CoreDataStack")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
              
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
