//
//  Devices+CoreDataProperties.swift
//  CustomAppDemo
//
//  Created by Eficens on 14/11/22.
//
//

import Foundation
import CoreData


extension Devices {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Devices> {
        return NSFetchRequest<Devices>(entityName: "Devices")
    }

    @NSManaged public var names: String?
    @NSManaged public var prices: Int16
    @NSManaged public var quantities: Int16

}

extension Devices : Identifiable {

}
