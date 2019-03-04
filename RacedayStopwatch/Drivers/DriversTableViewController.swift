//
//  DriversTableViewController.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 07/11/2018.
//  Copyright © 2018 Appbryggeriet. All rights reserved.
//

import UIKit
import CoreData

class DriversTableViewController: UITableViewController {
    
    //TODO: - "Future patch: add this footer view with different stats from db, load on viewdidload, show different stat on viewwillappear")
    @IBOutlet weak var footerView: UIView!
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Driver> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Driver> = Driver.fetchRequest()
        
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
        self.title          = Constants.DRIVERS_TITLE
        footerView.isHidden = true
        do {
            try fetchedResultsController.performFetch()
        } catch  {
            let error = error as NSError
            print("Unable to fetch drivers: \(String(describing: error.localizedFailureReason))")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AddDriverSegue"){
            let newDriver = segue.destination as! AddItemViewController
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DriverTableViewCell.reuseIdentifier, for: indexPath) as! DriverTableViewCell
        cell.setup(with: fetchedResultsController.fetchedObjects![indexPath.row])
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
        let editAction = UIContextualAction.init(style: .normal, title: "") { (action, view, completionHandler) in
            //perform segue to edit
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let editDriver = storyboard.instantiateViewController(withIdentifier: "editDriver") as! AddItemViewController
            editDriver.driver =  self.fetchedResultsController.fetchedObjects![indexPath.row]
            self.present(editDriver, animated: true, completion: nil)
            completionHandler(true)
        }
        editAction.backgroundColor  = .blue
        editAction.image            = UIImage(named: "delete-50-filled")
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}

extension DriversTableViewController: NSFetchedResultsControllerDelegate{
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
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? DriverTableViewCell{
                cell.setup(with: fetchedResultsController.fetchedObjects![indexPath.row])
            }
            break;
        default:
            print("...")
        }
    }
}
