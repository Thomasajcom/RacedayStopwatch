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
        self.navigationController?.navigationBar.prefersLargeTitles = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //empty footer to remove tableview lines
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sessionDateAndTime", ascending: true)]
        do {
            sessions = try CoreDataService.context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
       
        tableView.reloadData()
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
        print("number of sessions: \(sessions.count)")
        return sessions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let session = sessions[indexPath.row]
        print("in CellForRowAt hvor session er: \(session.sessionDateAndTime!.description) og indexpath er: \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: SessionTableViewCell.reuseIdentifier) as! SessionTableViewCell
        cell.setup(with: sessions[indexPath.row])
        return cell
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
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        #warning("temp implementation")
        return 200
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction.init(style: .destructive, title: "Delete Session") { (action, view, completionHandler) in
            CoreDataService.context.delete(self.sessions[indexPath.row])
            CoreDataService.saveContext()
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let moreInfoAction = UIContextualAction.init(style: .normal, title: "More Info") { _,_,_  in
            print("lol????")
            return
        }
        return UISwipeActionsConfiguration(actions: [moreInfoAction])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Did Select Row: \(indexPath.row)")
        print("Session:\(sessions[indexPath.row])")
    }

     // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "timerSegue"){
            let newTimer = segue.destination as! TimerViewController
            newTimer.hidesBottomBarWhenPushed = true
        }
    }
}
