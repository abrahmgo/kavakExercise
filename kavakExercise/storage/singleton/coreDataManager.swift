//
//  coreDataManager.swift
//  kavakExercise
//
//  Created by Andrés Bonilla on 12/4/19.
//  Copyright © 2019 Andrés Abraham Bonilla Gómez. All rights reserved.
//

import Foundation
import CoreData

class coreDataManager {
    
    static let shared = coreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "kevak")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () -> Bool{
        let context = coreDataManager.shared.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                return true
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        return false
    }
    
    func deleteAllData(_ entity:String) {
        let context = coreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
    
    func searchRegister(_ entity:String, id: String) -> [NSManagedObject]? {
        let context = coreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            return result
            
        } catch let error {
            print("Register in\(entity) not found error :", error)
            return nil
        }
    }
    
    func deleteRegister(_ entity:String, id: String) -> Bool {
        let context = coreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            context.delete(result[0])
            _ = coreDataManager.shared.saveContext()
            return true
            
        } catch let error {
            print("Register in\(entity) not found error :", error)
            return false
        }
    }
    
    func updateRegister(_ entity:String, id: String, date: String) -> Bool {
        let context = coreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            let object = result[0]
            object.setValue(date, forKey: "dateNotification")
            coreDataManager.shared.saveContext()
            return true
            
        } catch let error {
            print("the register in \(entity) can be updatade error :", error)
            return false
        }
    }
}
