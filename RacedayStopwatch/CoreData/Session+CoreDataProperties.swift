//
//  Session+CoreDataProperties.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 08/11/2018.
//  Copyright © 2018 Appbryggeriet. All rights reserved.
//
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var sessionDateAndTime: NSDate
    @NSManaged public var weatherInfo: String?
    @NSManaged public var onTrack: Track?
    @NSManaged public var drivers: NSSet?
    @NSManaged public var fastestDriver: Driver?
    @NSManaged public var fastestLapTime: String?
    @NSManaged public var fastestLapSpeed: String?
    @NSManaged public var numberOfLaps: Int16
    @NSManaged public var timeOnTrack: Int16

}

// MARK: Generated accessors for drivers
extension Session {

    @objc(addDriversObject:)
    @NSManaged public func addToDrivers(_ value: Driver)

    @objc(removeDriversObject:)
    @NSManaged public func removeFromDrivers(_ value: Driver)

    @objc(addDrivers:)
    @NSManaged public func addToDrivers(_ values: NSSet)

    @objc(removeDrivers:)
    @NSManaged public func removeFromDrivers(_ values: NSSet)

}
