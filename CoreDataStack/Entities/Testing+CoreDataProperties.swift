//
//  Testing+CoreDataProperties.swift
//  CoreDataStack
//
//  Created by Александр Коробицын on 10.11.2022.
//
//

import Foundation
import CoreData


extension Testing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Testing> {
        return NSFetchRequest<Testing>(entityName: "Testing")
    }

    @NSManaged public var defaultString: String?
    @NSManaged public var defaultNumber: Int64
    @NSManaged public var date: Date?

}

extension Testing : Identifiable {

}
