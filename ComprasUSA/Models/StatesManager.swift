//
//  StatesManager.swift
//  ComprasUSA
//
//  Created by Ronaldo Garcia on 15/12/18.
//  Copyright © 2018 Carol Renan Ronaldo. All rights reserved.
//

import CoreData

class StatesManager {
    
    static let share = StatesManager()
    
    var states: [State] = []
    
    func loadStates(with context: NSManagedObjectContext) {
        
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            states = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteState(index: Int, context: NSManagedObjectContext) {
        
        let state = states[index]
        context.delete(state)
        
        do {
            try context.save()
            states.remove(at: index)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    private init() {
        
    }
}
