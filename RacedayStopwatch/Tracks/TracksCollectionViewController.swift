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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            textField.placeholder = Constants.TRACK_NAME_PLACEHOLDER
        }
        alertController.addTextField { (textField) in
            textField.placeholder   = Constants.TRACK_LENGTH_PLACEHOLDER + Constants.TRACK_LENGTH_UNIT
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
        guard let intLength = Int16(length) else{return}
        let track = Track(context: CoreDataService.context)
        track.name = trackName
        track.length = intLength
        #warning("this must be changed - add image selector in app, set that image here, or default if no photo selected")
        track.image = UIImage(named: "defaultTrack")!.pngData()
        CoreDataService.saveContext()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
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
    

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: Constants.TRACK_ALERT_DELETE_TITLE, message: Constants.TRACK_ALERT_DELETE_BODY, preferredStyle: .alert)
        let addAction = UIAlertAction(title: Constants.TRACK_ALERT_DELETE_TITLE, style: .destructive) {[unowned self] action in
            self.deleteTrack(self.fetchedResultsController.object(at: indexPath))
        }
        let cancelAction = UIAlertAction(title: Constants.ALERT_CANCEL, style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func deleteTrack(_ track: Track){
        CoreDataService.context.delete(track)
        CoreDataService.saveContext()
    }

}

//NSFetchedResultsControllerDelegate extension
extension TracksCollectionViewController: NSFetchedResultsControllerDelegate {

    #warning("Known Bug: adding tracks sometimes fails to show changes")
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                collectionView.insertItems(at: [indexPath])
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        case .update:
            print("i controller update")
            if let indexPath = indexPath, let cell = collectionView.cellForItem(at: indexPath){
                print("i TRACKScontroller update IF LET")
                //setup(cell, at: indexPath)
            }
        case .delete:
            if let indexPath = indexPath {
                print("i controller delete IF LET")
                collectionView.deleteItems(at: [indexPath])
            }
        default:
            print("...")
        }
    }

}
