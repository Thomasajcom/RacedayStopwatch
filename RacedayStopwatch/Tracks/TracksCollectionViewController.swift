//
//  TracksCollectionViewController.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 29/01/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import UIKit
import CoreData



class TracksCollectionViewController: UICollectionViewController {
    
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
        do {
            try fetchedResultsController.performFetch()
        } catch  {
            let error = error as NSError
            print("Unable to fetch tracks: \(error)")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func addTrack(_ sender: Any) {
        let alertController = UIAlertController(title: "Add New Track", message: "Enter name and length to add a new track", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Track name"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Length in meters"
        }
        let addAction = UIAlertAction(title: "Add Track", style: .default) {[unowned self] action in
            guard let firstField = alertController.textFields?.first,
                let trackName = firstField.text else {return}
            guard let secondField = alertController.textFields?[1],
                let length = secondField.text else {return}
            
            self.addToCoreData(trackName: trackName, length: length)
        }//thisll add to db
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func addToCoreData(trackName: String, length: String){
        print("i addToCoreData \(trackName) lengde: \(length)")
        guard let intLength = Int16(length) else{return}
        let track = Track(context: CoreDataService.context)
        track.name = trackName
        track.length = intLength
        CoreDataService.saveContext()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        print("numberOfSections")

        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        guard let tracks = fetchedResultsController.fetchedObjects else { return 0 }
        return tracks.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCollectionViewCell.reuseIdentifier, for: indexPath) as! TrackCollectionViewCell
        let track = fetchedResultsController.object(at: indexPath)
        cell.setup(track)
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

//NSFetchedResultsControllerDelegate extension
extension TracksCollectionViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                collectionView.insertItems(at: [indexPath])
            }
        case .update:
            print("i controller update")
            if let indexPath = indexPath, let cell = collectionView.cellForItem(at: indexPath){
                print("i controller update IF LET")
                //setup(cell, at: indexPath)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
//                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            print("...")
        }
    }

}