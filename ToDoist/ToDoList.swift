//
//  ToDoList.swift
//  ToDoist
//
//  Created by Lars Dansie on 12/12/23.
//

import Foundation

extension ToDoList{
    var itemArray: [Item] {
        guard let array = items?.allObjects as? [Item] else { return [] }
        return array
    }
}
