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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AddTrackSegue"){
            
            let newDriver = segue.destination as! AddItemViewController
            newDriver.itemIsTrack = true
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var shouldPerformSegue = true
        if (identifier == "AddTrackSegue"){
            if ((fetchedResultsController.fetchedObjects?.count)! >= Constants.IAP_TRACK_LIMIT) {
                print("over the limit, unlock unlimited tracks spots and remove the track ads by clicking purchase")
                shouldPerformSegue = false
            }
        }
        return shouldPerformSegue
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
        deleteAction.image              = UIImage(named: "delete-50-filled")
        deleteAction.backgroundColor    = UIColor(named: "DeleteColor")
        let editAction = UIContextualAction.init(style: .normal, title: "") { (action, view, completionHandler) in
            //perform segue to edit
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let editTrack = storyboard.instantiateViewController(withIdentifier: "editItem") as! AddItemViewController
            editTrack.itemIsTrack = true
            editTrack.track = self.fetchedResultsController.object(at: indexPath)
            self.present(editTrack, animated: true, completion: nil)
            completionHandler(true)
        }
        editAction.backgroundColor  = UIColor(named: "ConfirmColor")
        editAction.image            = UIImage(named: "delete-50-filled")
        return UISwipeActionsConfiguration(actions: [editAction, deleteAction])
    }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
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
