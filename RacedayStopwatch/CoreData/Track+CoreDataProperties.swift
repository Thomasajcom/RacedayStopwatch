//
//  Track+CoreDataProperties.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 08/11/2018.
//  Copyright © 2018 Appbryggeriet. All rights reserved.
//
//

import Foundation
import CoreData


extension Track {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Track> {
        return NSFetchRequest<Track>(entityName: "Track")
    }

    @NSManaged public var name: String
    @NSManaged public var length: Int16
    @NSManaged public var trackRecord: String?
    @NSManaged public var trackRecordHolder: Driver?
    @NSManaged public var sessions: NSSet?

}

// MARK: Generated accessors for sessions
extension Track {

    @objc(addSessionsObject:)
    @NSManaged public func addToSessions(_ value: Session)

    @objc(removeSessionsObject:)
    @NSManaged public func removeFromSessions(_ value: Session)

    @objc(addSessions:)
    @NSManaged public func addToSessions(_ values: NSSet)

    @objc(removeSessions:)
    @NSManaged public func removeFromSessions(_ values: NSSet)

}
