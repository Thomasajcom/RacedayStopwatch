//
//  TracksTableViewController.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 01/03/2019.
//  Copyright © 2019 Appbryggeriet. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

class TracksTableViewController: UITableViewController {
    
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeLargeBanner)
        adBannerView.adUnitID = Constants.ADMOB_ID_DRIVERS
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        return adBannerView
    }()
    
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
        tableView.tableFooterView = UIView()
        //self.title = Constants.TRACKS_TITLE
        do {
            try fetchedResultsController.performFetch()
        } catch  {
            let error = error as NSError
            print("Unable to fetch tracks: \(error)")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(!Constants.store.isProductPurchased(Constants.IAP_REMOVE_ADS_ID) || !Constants.store.isProductPurchased(Constants.IAP_REMOVE_ALL_ID)){
            displayAds()
        }else{
            tableView.tableHeaderView = nil
        }
        tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupTheme()
    }
    
    func setupTheme(){
        navigationController?.navigationBar.barTintColor = Theme.activeTheme.barColor
        navigationController?.navigationBar.tintColor = Theme.activeTheme.tintColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:Theme.activeTheme.tintColor]
        navigationController?.navigationBar.largeTitleTextAttributes   = [NSAttributedString.Key.foregroundColor:Theme.activeTheme.tintColor]
        tabBarController?.tabBar.barTintColor = Theme.activeTheme.barColor
        tabBarController?.tabBar.tintColor = Theme.activeTheme.tintColor
        tableView.separatorColor    = Theme.activeTheme.tintColor
        tableView.backgroundColor   = Theme.activeTheme.backgroundColor
        tableView.separatorColor    = Theme.activeTheme.tintColor
    }
    func displayAds(){
        if fetchedResultsController.fetchedObjects!.count > 0{
            let request             = GADRequest()
            request.testDevices     = [kGADSimulatorID]
            adBannerView.load(request)
        }else{
            tableView.tableHeaderView = nil
        }
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
            if ((fetchedResultsController.fetchedObjects?.count)! >= Constants.IAP_TRACK_LIMIT && !Constants.store.isProductPurchased(Constants.IAP_REMOVE_LIMITS_ID)) {
                let alertController = UIAlertController(title: Constants.IAP_LIMIT_REACHED_TITLE, message: Constants.IAP_LIMIT_REACHED_BODY, preferredStyle: .alert)
                let okAction = UIAlertAction(title: Constants.ALERT_OK, style: .default) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(okAction)
                present(alertController, animated: true)
                shouldPerformSegue = false
            }
        }
        return shouldPerformSegue
    }
    
    func resetStats(_ track: Track) {
        let alertController = UIAlertController(title: Constants.TRACK_RESET_TITLE, message: Constants.TRACK_RESET_BODY, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Constants.ALERT_CANCEL, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let okAction = UIAlertAction(title: Constants.ALERT_OK, style: .destructive) { (action) in
            track.resetRecord()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    func deleteTrack(_ track: Track){
        let alertController = UIAlertController(title: Constants.TRACK_ALERT_DELETE_TITLE, message: Constants.TRACK_ALERT_DELETE_BODY, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Constants.ALERT_CANCEL, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let okAction = UIAlertAction(title: Constants.ALERT_OK, style: .destructive) { (action) in
            CoreDataService.context.delete(track)
            CoreDataService.saveContext()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true)
        
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
        let resetAction = UIContextualAction.init(style: .normal, title: "") { (action, view, completionHandler) in
            //perform segue to edit
            let track = self.fetchedResultsController.object(at: indexPath)
            self.resetStats(track)
            completionHandler(true)
        }
        let editAction = UIContextualAction.init(style: .normal, title: "") { (action, view, completionHandler) in
            //perform segue to edit
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let editTrack = storyboard.instantiateViewController(withIdentifier: "editItem") as! AddItemViewController
            editTrack.itemIsTrack = true
            editTrack.track = self.fetchedResultsController.object(at: indexPath)
            self.present(editTrack, animated: true, completion: nil)
            completionHandler(true)
        }
        editAction.backgroundColor  = Theme.activeTheme.foregroundColor
        editAction.image            = UIImage(named: "delete-50-filled")
        return UISwipeActionsConfiguration(actions: [editAction, resetAction])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction.init(style: .normal, title: nil) { (action, view, completionHandler) in
            completionHandler(true)
            let track = self.fetchedResultsController.object(at: indexPath)
            self.deleteTrack(track)
            completionHandler(true)
        }
        deleteAction.image              = UIImage(named: "delete-50-filled")
        deleteAction.backgroundColor    = Theme.activeTheme.deleteColor
        return UISwipeActionsConfiguration(actions: [deleteAction])

    }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
}

//MARK: - AdMob Banner Delegate
extension TracksTableViewController: GADBannerViewDelegate{
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        tableView.tableHeaderView?.frame = bannerView.frame
        tableView.tableHeaderView = bannerView
    }
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
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
