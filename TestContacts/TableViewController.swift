//
//  TableViewController.swift
//  TestContacts
//
//  Created by Dave on 11/8/18.
//  Copyright © 2018 DaKar. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate {
    
    var frc : NSFetchedResultsController = NSFetchedResultsController<NSFetchRequestResult>()
    
    var pc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
   
    @IBOutlet weak var searchbar: UISearchBar!
    
    func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        let sorter = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sorter]
        return fetchRequest
        
    }
    
    func getFRC() -> NSFetchedResultsController<NSFetchRequestResult> {
        
        frc = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: pc, sectionNameKeyPath: nil, cacheName: nil)
        return frc
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        frc = getFRC()
        frc.delegate = self
        
        do {
            try frc.performFetch()
            
        }
        catch {
            
            print(error)
            return
            
        }
         searchbar.delegate = self
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let numberOfRows = frc.sections?[section].numberOfObjects
        return numberOfRows!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        let item = frc.object(at: indexPath) as! Entity
        cell.cellTitle.text = item.name
        cell.cellDescription.text = item.telephone
        cell.cellGender.text = item.gender

        return cell
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
         tableView.reloadData()
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let  managedObj : NSManagedObject = frc.object(at: indexPath) as! NSManagedObject
        pc.delete(managedObj)
        
        do {
            try pc.save()
        }
        catch {
            print(error)
            return
        }
    }
    

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

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            
            let itemController : AddingViewController = segue.destination as! AddingViewController
            let item : Entity = frc.object(at: indexPath!) as! Entity
            
            itemController.item = item
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}
