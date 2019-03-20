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
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Session> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sessionDateAndTime", ascending: false)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataService.context, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
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
        do {
            try fetchedResultsController.performFetch()
        } catch  {
            let error = error as NSError
            print("Unable to fetch tracks: \(error)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.backgroundColor   = Theme.activeTheme.backgroundColor
        tableView.separatorColor    = Theme.activeTheme.tintColor
       
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
        let deleteFetch     = NSFetchRequest<NSFetchRequestResult>(entityName: table)
        let deleteRequest   = NSBatchDeleteRequest(fetchRequest: deleteFetch)
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
        let dropSessions    = UIAlertAction(title: "Session", style: .destructive, handler: {(alert: UIAlertAction!) in
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
    
    func deleteSession(_ session: Session){
        let alertController = UIAlertController(title: Constants.SESSION_ALERT_DELETE_TITLE, message: Constants.SESSION_ALERT_DELETE_BODY, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Constants.ALERT_CANCEL, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let okAction = UIAlertAction(title: Constants.ALERT_OK, style: .destructive) { (action) in
            CoreDataService.context.delete(session)
            CoreDataService.saveContext()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true)
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sessions = fetchedResultsController.fetchedObjects else { return 0 }
        return sessions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SessionTableViewCell.reuseIdentifier) as! SessionTableViewCell
        let session = fetchedResultsController.object(at: indexPath)
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
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction.init(style: .normal, title: nil) { (action, view, completionHandler) in
            let session = self.fetchedResultsController.object(at: indexPath)
            self.deleteSession(session)
            completionHandler(true)
        }
        deleteAction.image              = UIImage(named: "delete-50-filled")
        deleteAction.backgroundColor    = UIColor(named: "DeleteColor")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    //removes the default delete action for trailingswipe
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return .none
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Did Select Row: \(indexPath.row)")
        print("Session:\(sessions[indexPath.row])")
    }

}

extension SessionsTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? SessionTableViewCell{
                cell.setup(with: fetchedResultsController.fetchedObjects![indexPath.row])
            }
            break;
        default:
            print("...")
        }
    }
}

