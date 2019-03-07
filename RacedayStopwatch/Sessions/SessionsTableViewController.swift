//
//  SessionsTableViewController.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 07/11/2018.
//  Copyright © 2018 Appbryggeriet. All rights reserved.
//

import UIKit
import CoreData

class SessionsTableViewController: UITableViewController {

    var sessions: [Session] = []
    let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set the measurement unit correctly, if this is the first launch of the app
        if !Constants.defaults.bool(forKey: Constants.defaults_launched_before){
            print("FØRSTE LAUNCH!!!")
            let locale = Locale.current
            let isMetric = locale.usesMetricSystem
            Constants.defaults.set(isMetric, forKey: Constants.defaults_metric_key)
            print(isMetric)
            print(Constants.defaults.bool(forKey: Constants.defaults_metric_key))
        }
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sessionDateAndTime", ascending: false)]
        do {
            sessions = try CoreDataService.context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
       
        tableView.reloadData()
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var shouldPerformSegue = true
        if (identifier == "NewSessionSegue"){
            if (sessions.count >= Constants.IAP_SESSION_LIMIT) {
                print("over the limit, unlock unlimited sessions and remove the session and timer ads by clicking purchase")
                shouldPerformSegue = false
            }
        }
        return shouldPerformSegue
    }

    // MARK: - Developer Options Core Data
    func drop(table: String){
        print("Going to drop table: \(table)")
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: table)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try CoreDataService.context.execute(deleteRequest)
            CoreDataService.saveContext()
            
        }
        catch
        {
            print ("There was an error")
        }
    }
    
    @IBAction func devButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Dev Menu", message: "Drop selected table!", preferredStyle: .actionSheet)
        let dropSessions = UIAlertAction(title: "Session", style: .destructive, handler: {(alert: UIAlertAction!) in
            self.drop(table: alert.title!)
        })
        let dropTracks = UIAlertAction(title: "Track", style: .destructive, handler: {(alert: UIAlertAction!) in
            self.drop(table: alert.title!)
        })
        let dropDrivers = UIAlertAction(title: "Driver", style: .destructive, handler: {(alert: UIAlertAction!) in
            self.drop(table: alert.title!)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(dropSessions)
        alertController.addAction(dropTracks)
        alertController.addAction(dropDrivers)
        alertController.addAction(cancelAction)
        present(alertController,animated: true)
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let session = sessions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SessionTableViewCell.reuseIdentifier) as! SessionTableViewCell
        cell.setup(with: session)
        return cell
    }
        
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction.init(style: .destructive, title: nil) { (action, view, completionHandler) in
            CoreDataService.context.delete(self.sessions[indexPath.row])
            CoreDataService.saveContext()
            do {
                self.sessions = try CoreDataService.context.fetch(self.fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            completionHandler(true)
        }
        deleteAction.image              = UIImage(named: "delete-50-filled")
        deleteAction.backgroundColor    = UIColor(named: "DeleteColor")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Did Select Row: \(indexPath.row)")
        print("Session:\(sessions[indexPath.row])")
    }

    
}
