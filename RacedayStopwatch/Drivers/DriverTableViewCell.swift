//
//  DriverTableViewCell.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 09/11/2018.
//  Copyright © 2018 Appbryggeriet. All rights reserved.
//

import UIKit
import CoreData

class DriverTableViewCell: UITableViewCell {

    static let reuseIdentifier = "DriverCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var sessionsLabel: UILabel!
    @IBOutlet weak var numberOfSessions: UILabel!
    
    @IBOutlet weak var fastestDriverLabel: UILabel!
    @IBOutlet weak var numberOfTimesFastestDriver: UILabel!
    
    let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
    
    var driverPredicate: NSPredicate?
    var fastestDriverPredicate: NSPredicate?

    func setup(with driver: Driver){
        numberLabel.layer.cornerRadius  = Constants.cornerRadius
        numberLabel.layer.masksToBounds = true
        numberLabel.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        driverImage.layer.cornerRadius  = Constants.cornerRadius
        driverImage.layer.masksToBounds = true
        nameLabel.text                  = driver.name
        if let driverNumber = driver.number{
            numberLabel.text        = "#\(driverNumber)"
        }else{
            numberLabel.isHidden    = true
        }
        driverImage.image   = UIImage(data: driver.image!)
        self.selectionStyle = .none
        getNumberOfSessions(for: driver)
        getFastestDriver(for: driver)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupTheme()
    }
    
    func setupTheme(){
        backgroundColor                         = Theme.activeTheme.foregroundColor
        nameLabel.textColor                     = Theme.activeTheme.highlightFontColor
        sessionsLabel.textColor                 = Theme.activeTheme.mainFontColor
        numberOfSessions.textColor              = Theme.activeTheme.mainFontColor
        fastestDriverLabel.textColor            = Theme.activeTheme.mainFontColor
        numberOfTimesFastestDriver.textColor    = Theme.activeTheme.mainFontColor
        numberLabel.backgroundColor             = Theme.activeTheme.highlightColor
        numberLabel.textColor                   = Theme.activeTheme.highlightFontColor
        
    }
    
    //get driver data for cell
    func getFastestDriver(for driver: Driver){
        fetchRequest.sortDescriptors    = [NSSortDescriptor(key: "sessionDateAndTime", ascending: true)]
        fastestDriverPredicate          = NSPredicate(format: "fastestDriver == %@", driver)
        fetchRequest.predicate          = fastestDriverPredicate
        do {
            let sessions                    = try CoreDataService.context.fetch(fetchRequest)
            fastestDriverLabel.text         = Constants.DRIVER_FASTEST_DRIVER
            numberOfTimesFastestDriver.text = String(sessions.count)
        } catch let error as NSError {
            fastestDriverLabel.isHidden             = true
            numberOfTimesFastestDriver.isHidden     = true
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    
    }
    func getNumberOfSessions(for driver: Driver){
        fetchRequest.sortDescriptors    = [NSSortDescriptor(key: "sessionDateAndTime", ascending: true)]
        driverPredicate                 = NSPredicate(format: "%@ IN  drivers", driver)
        fetchRequest.predicate          = driverPredicate
        do {
            let sessions            = try CoreDataService.context.fetch(fetchRequest)
            sessionsLabel.text      = Constants.DRIVER_SESSIONS
            numberOfSessions.text   = String(sessions.count)
        } catch let error as NSError {
            sessionsLabel.isHidden      = true
            numberOfSessions.isHidden   = true
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
