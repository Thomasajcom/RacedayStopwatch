//
//  TracksTableViewController.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 07/11/2018.
//  Copyright © 2018 Appbryggeriet. All rights reserved.
//

import UIKit
import CoreData

class TracksTableViewController: UITableViewController {
    
    static let reuseIdentifier = "TrackCell"
    
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
    
    

    
    
    func updateTrack(track: Track, newTrackName: String, newLength: String, indexPath: IndexPath){
        guard let intLength = Int16(newLength) else{return}
        print("i updateTrack \(newTrackName) : \(intLength)")
        track.name = newTrackName
        track.length = intLength
    }
    
    func setup(_ cell: UITableViewCell, at indexPath: IndexPath){
        print("i SETUP")
        let track = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = track.name
        cell.detailTextLabel?.text = "Meters: \(track.length)"
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try fetchedResultsController.performFetch()
        } catch  {
            let error = error as NSError
            print("Unable to fetch tracks")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            try fetchedResultsController.performFetch()
        } catch  {
            let error = error as NSError
            print("Unable to fetch tracks")
        }
        tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: TracksTableViewController.reuseIdentifier, for: indexPath)
        let track = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = track.name
        cell.detailTextLabel?.text = "Meters: \(track.length)"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = fetchedResultsController.object(at: indexPath)

        let alertController = UIAlertController(title: "Edit Track", message: "Edit name and length!", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = track.name
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "\(track.length)"
        }
        let addAction = UIAlertAction(title: "Edit", style: .default) {[unowned self] action in
            guard let firstField = alertController.textFields?.first,
                let trackName = firstField.text else {return}
            guard let secondField = alertController.textFields?[1],
                let length = secondField.text else {return}
            
            self.updateTrack(track: track,newTrackName: trackName, newLength: length, indexPath: indexPath)
        }//thisll add to db
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TracksTableViewController: NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .update:
            print("i controller update")
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath){
                print("i controller update IF LET")
                setup(cell, at: indexPath)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            print("...")
        }
    }
    
}
