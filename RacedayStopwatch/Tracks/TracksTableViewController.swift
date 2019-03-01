//
//  TracksTableViewController.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 01/03/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import UIKit
import CoreData

class TracksTableViewController: UITableViewController {
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Track> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataService.context, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.TRACKS_TITLE
        do {
            try fetchedResultsController.performFetch()
        } catch  {
            let error = error as NSError
            print("Unable to fetch tracks: \(error)")
        }
        tableView.tableFooterView = UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
    }

    @IBAction func add(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add New Track", message: "Enter name and length to add a new track", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = Constants.TRACK_NAME_PLACEHOLDER
        }
        alertController.addTextField { (textField) in
            textField.placeholder   = Constants.TRACK_LENGTH_PLACEHOLDER + (Constants.defaults.bool(forKey: Constants.defaults_metric_key) ? Constants.TRACK_LENGTH_UNIT_METERS : Constants.TRACK_LENGTH_UNIT_MILES)
            textField.keyboardType  = UIKeyboardType.numberPad
        }
        let addAction = UIAlertAction(title: Constants.TRACK_ALERT_ADD_TRACK_TITLE, style: .default) {[unowned self] action in
            guard let firstField = alertController.textFields?.first,
                let trackName = firstField.text else {return}
            guard let secondField = alertController.textFields?[1],
                let length = secondField.text else {return}
            
            self.addToCoreData(trackName: trackName, length: length)
        }//thisll add to db
        let cancelAction = UIAlertAction(title: Constants.ALERT_CANCEL, style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
        func addToCoreData(trackName: String, length: String){
            guard let doubleLength = Double(length) else{return}
            let track = Track(context: CoreDataService.context)
            track.name = trackName
            if Constants.defaults.bool(forKey: Constants.defaults_metric_key){
                track.length = doubleLength
            }else{
                track.length = doubleLength.fromMilesToMeters()
            }
            track.trackRecord = 0
            CoreDataService.saveContext()
        }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tracks = fetchedResultsController.fetchedObjects else { return 0 }
        return tracks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackTableViewCell.reuseIdentifier, for: indexPath) as! TrackTableViewCell
        let track = fetchedResultsController.object(at: indexPath)
        cell.setup(track)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction.init(style: .normal, title: nil) { (action, view, completionHandler) in
            completionHandler(true)
            let deleteObject = self.fetchedResultsController.object(at: indexPath)
            CoreDataService.context.delete(deleteObject)
            CoreDataService.saveContext()
            completionHandler(true)
        }
        deleteAction.image = UIImage(named: "delete-50-filled")
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

//NSFetchedResultsControllerDelegate extension
extension TracksTableViewController: NSFetchedResultsControllerDelegate {
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
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? TrackTableViewCell{
                cell.setup(fetchedResultsController.fetchedObjects![indexPath.row])
            }
            break;
        default:
            print("...")
        }
    }
}
