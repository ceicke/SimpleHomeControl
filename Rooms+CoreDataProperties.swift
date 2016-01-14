//
//  Rooms+CoreDataProperties.swift
//  SimpleHomeControl
//
//  Created by Christoph Eicke on 14.01.16.
//  Copyright © 2016 Christoph Eicke. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Rooms {

    @NSManaged var name: String?
    @NSManaged var uuid: String?

}
