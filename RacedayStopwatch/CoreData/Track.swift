//
//  Track.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 13/02/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import UIKit
import CoreData

class Track: NSManagedObject {

    func resetRecord(){
        self.trackRecord = 0
        self.trackRecordHolder = nil
        CoreDataService.saveContext()
    }
}
