//
//  DriversTableViewController.swift
//  RacedayStopwatch
//
//  Created by Thomas Andre Johansen on 07/11/2018.
//  Copyright © 2018 Appbryggeriet. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

class DriversTableViewController: UITableViewController {
    
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeLargeBanner)
        adBannerView.adUnitID = Constants.ADMOB_ID_DRIVERS
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        return adBannerView
    }()
    
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
        tableView.tableFooterView = UIView()
        //self.title = Constants.DRIVERS_TITLE
        do {
            try fetchedResultsController.performFetch()
        } catch  {
            let error = error as NSError
            print("Unable to fetch drivers: \(String(describing: error.localizedFailureReason))")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(Constants.store.isProductPurchased(Constants.IAP_REMOVE_ADS_ID) || Constants.store.isProductPurchased(Constants.IAP_REMOVE_ALL_ID)){
            tableView.tableHeaderView = nil
        }else{
            displayAds()
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
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID]
            adBannerView.load(request)
        }else{
            tableView.tableHeaderView = nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AddDriverSegue"){
            let newDriver = segue.destination as! AddItemViewController
            newDriver.itemIsDriver = true
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var shouldPerformSegue = true
        if (identifier == "AddDriverSegue"){
            if ((fetchedResultsController.fetchedObjects?.count)! >= Constants.IAP_DRIVER_LIMIT && !Constants.store.isProductPurchased(Constants.IAP_REMOVE_LIMITS_ID)) {
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
    
    func deleteDriver(_ driver: Driver){
        let alertController = UIAlertController(title: Constants.DRIVER_ALERT_DELETE_TITLE, message: Constants.DRIVER_ALERT_DELETE_BODY, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Constants.ALERT_CANCEL, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let okAction = UIAlertAction(title: Constants.ALERT_OK, style: .destructive) { (action) in
            CoreDataService.context.delete(driver)
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
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DriverTableViewCell.reuseIdentifier, for: indexPath) as! DriverTableViewCell
        cell.setup(with: fetchedResultsController.fetchedObjects![indexPath.row])
        return cell
    }

    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction.init(style: .normal, title: "") { (action, view, completionHandler) in
            //perform segue to edit
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let editDriver = storyboard.instantiateViewController(withIdentifier: "editItem") as! AddItemViewController
            editDriver.itemIsDriver = true
            editDriver.driver =  self.fetchedResultsController.fetchedObjects![indexPath.row]
            self.present(editDriver, animated: true, completion: nil)
            completionHandler(true)
        }
        editAction.backgroundColor  = Theme.activeTheme.backgroundColor
        editAction.image            = UIImage(named: "swipe_edit")
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction.init(style: .normal, title: nil) { (action, view, completionHandler) in
            completionHandler(true)
            let driver = self.fetchedResultsController.object(at: indexPath)
            self.deleteDriver(driver)
            completionHandler(true)
        }
        deleteAction.image              = UIImage(named: "swipe_delete")
        deleteAction.backgroundColor    = Theme.activeTheme.deleteColor
        return UISwipeActionsConfiguration(actions: [deleteAction])
        
    }
    

}
//MARK: - AdMob Banner Delegate
extension DriversTableViewController: GADBannerViewDelegate{
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        tableView.tableHeaderView?.frame = bannerView.frame
        tableView.tableHeaderView = bannerView
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
}



//MARK: - NSFetchedResultsControllerDelegate
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
