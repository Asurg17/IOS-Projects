//
//  Contacts+CoreDataProperties.swift
//  ContactBook
//
//  Created by Aleksandre Surguladze on 11.01.22.
//
//

import Foundation
import CoreData


extension Contacts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contacts> {
        return NSFetchRequest<Contacts>(entityName: "Contacts")
    }

    @NSManaged public var name: String?
    @NSManaged public var number: String?

}

extension Contacts : Identifiable {

}
