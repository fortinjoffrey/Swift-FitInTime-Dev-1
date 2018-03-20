//
//  CoreDataManager.swift
//  myappv1testagain
//
//  Created by Joffrey Fortin on 18/03/2018.
//  Copyright © 2018 myCode. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
    
    
    func fetchTrainings() -> [Training]{
        
        let context = persistentContainer.viewContext
        
        let request = NSFetchRequest<Training>(entityName: "Training")
        
        do {
            let trainings = try context.fetch(request)
            return trainings
        } catch let fetchErr {
            print("Failed to fetch trainings from Core Data:", fetchErr)
            return []
        }
    }
    
    func deleteTraining(training: Training) -> Bool {
        
        let context = persistentContainer.viewContext
        context.delete(training)
        
        do {
            try context.save()
            return true
        } catch let saveErr {
            print("Failed to save deletion:", saveErr)
            return false
        }        
    }
    
    func executeBatchDeleteRequest() -> Bool {
        
        let context = persistentContainer.viewContext
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Training.fetchRequest())
        do {
            try context.execute(batchDeleteRequest)
            return true
        } catch let deleteErr {
            print("Failed to delete objects:", deleteErr)
            return false
        }
    }
    
    func createExercice(exerciceName: String, training: Training) -> (Exercice?, Error?) {
        
        let context = persistentContainer.viewContext
        
        let exercice = NSEntityDescription.insertNewObject(forEntityName: "Exercice", into: context) as! Exercice
        
        exercice.name = exerciceName
        exercice.training = training
        
        do {
            try context.save()
            return (exercice, nil)
        } catch let saveErr {
            print("Failed to create exercice:", saveErr)
            return (nil, saveErr)
        }
    }
    
    func deleteExercice(exercice: Exercice) -> Bool {
        
        let context = persistentContainer.viewContext
        context.delete(exercice)
        
        do {
            try context.save()
            return true
        } catch let saveErr {
            print("Failed to save deletion:", saveErr)
            return false
        }
    }
    
}
