//
//  ItemManager.swift
//  ToDoist
//
//  Created by Parker Rushton on 10/21/22.
//

import Foundation
import CoreData

class ItemManager {
    static let shared = ItemManager()

    // Create
    
    func createNewItem(with title: String, in list: ToDoList) {
        let newItem = Item(context: PersistenceController.shared.viewContext)
        
        newItem.id = UUID().uuidString
        newItem.title = title
        newItem.createdAt = Date()
        newItem.completedAt = nil
        
        newItem.toDoList = list
        
        PersistenceController.shared.saveContext()
    }
    
    func createNewList(with title: String) {
        let newList = ToDoList(context: PersistenceController.shared.viewContext)
        newList.id = UUID().uuidString
        newList.title = title
        newList.createdAt = Date()
        newList.modifiedAt = Date()
        
        PersistenceController.shared.saveContext()
    }

    
    private func fetchItems(matching predicate: NSPredicate) -> [Item] {
        let fetchRequest = Item.fetchRequest()
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let context = PersistenceController.shared.viewContext
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching items: \(error)")
            return []
        }
    }
    
    func fetchIncompleteItems() -> [Item] {
        return fetchItems(matching: NSPredicate(format: "completedAt == nil"))
  }
    func fetchCompletedItems() -> [Item] {
//        let sortDescriptor = NSSortDescriptor(key: "modifiedAt", ascending: false)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        I don't understand why this was said to be in here or how I am supposed to make it 'work'
        return fetchItems(matching: NSPredicate(format: "completedAt != nil"))
  }

    
    func allLists() -> [ToDoList] {
        let fetchRequest = ToDoList.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "modifiedAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedLists = try? PersistenceController.shared.viewContext.fetch(fetchRequest)
        return fetchedLists ?? []
    }
    
    private func item(at indexPath: IndexPath) -> Item {
        let items = indexPath.section == 0 ? fetchIncompleteItems() : fetchCompletedItems()
        return items[indexPath.row]
    }
    
    // Update
    
    func toggleItemCompletion(_ item: Item) {
        item.completedAt = item.isCompleted ? nil : Date()
        PersistenceController.shared.saveContext()
    }
    
    
    // Delete
    
    func remove(_ item: Item) {
      let context = PersistenceController.shared.viewContext
      context.delete(item)
      PersistenceController.shared.saveContext()
  }
    
    func deleteList(at indexPath: IndexPath) {
        let context = PersistenceController.shared.viewContext
        let list = allLists()[indexPath.row]
        context.delete(list)
        PersistenceController.shared.saveContext()
    }

}
