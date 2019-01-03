//
//  Driver+CoreDataProperties.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 08/11/2018.
//  Copyright © 2018 Appbryggeriet. All rights reserved.
//
//

import Foundation
import CoreData


extension Driver {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Driver> {
        return NSFetchRequest<Driver>(entityName: "Driver")
    }

    @NSManaged public var name: String
    @NSManaged public var color: String?
    @NSManaged public var image: NSData?
    @NSManaged public var favoriteTrack: String?
    @NSManaged public var holdsRecords: NSSet?
    @NSManaged public var sessions: NSSet?

}

// MARK: Generated accessors for holdsRecords
extension Driver {

    @objc(addHoldsRecordsObject:)
    @NSManaged public func addToHoldsRecords(_ value: Track)

    @objc(removeHoldsRecordsObject:)
    @NSManaged public func removeFromHoldsRecords(_ value: Track)

    @objc(addHoldsRecords:)
    @NSManaged public func addToHoldsRecords(_ values: NSSet)

    @objc(removeHoldsRecords:)
    @NSManaged public func removeFromHoldsRecords(_ values: NSSet)

}

// MARK: Generated accessors for sessions
extension Driver {

    @objc(addSessionsObject:)
    @NSManaged public func addToSessions(_ value: Session)

    @objc(removeSessionsObject:)
    @NSManaged public func removeFromSessions(_ value: Session)

    @objc(addSessions:)
    @NSManaged public func addToSessions(_ values: NSSet)

    @objc(removeSessions:)
    @NSManaged public func removeFromSessions(_ values: NSSet)

}
