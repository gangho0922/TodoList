//
//  ListContents+CoreDataProperties.swift
//  TodoList
//
//  Created by AnnKangHo on 2023/06/15.
//
//

import Foundation
import CoreData


extension ListContents {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListContents> {
        return NSFetchRequest<ListContents>(entityName: "ListContents")
    }

    @NSManaged public var sentence: String?
    @NSManaged public var dates: Date?

}

extension ListContents : Identifiable {

}
