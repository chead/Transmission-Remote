//
//  TransmissionServicesTableViewController.swift
//  Transmission Remote
//
//  Created by 👽 on 4/22/20.
//  Copyright © 2020 chead. All rights reserved.
//

import UIKit
import CoreData

class TransmissionServicesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var managedObjectContext: NSManagedObjectContext!

    private var selectedTransmissionService: TransmissionService?

    lazy var fetchedResultsController: NSFetchedResultsController<TransmissionService> = {
        let transissionServersFetchRequest: NSFetchRequest<TransmissionService> = NSFetchRequest(entityName: "TransmissionService")

        transissionServersFetchRequest.sortDescriptors = [NSSortDescriptor(key: "created", ascending: true)]
        
        var fetchedResultsController = NSFetchedResultsController(fetchRequest: transissionServersFetchRequest,
                                                                  managedObjectContext: self.managedObjectContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)

        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }

        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        //self.navigationItem.leftBarButtonItem = editButtonItem
        //self.tableView.allowsSelectionDuringEditing = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections!.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = self.fetchedResultsController.sections!
        let sectionInfo = sections[section]

        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transmissionServiceTableViewCell", for: indexPath)

        let transmissionService = self.fetchedResultsController.object(at: indexPath)

        cell.textLabel?.text = transmissionService.name

        return cell
    }

//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return false
//    }

//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let context = self.fetchedResultsController.managedObjectContext
//
//            context.delete(fetchedResultsController.object(at: indexPath))
//
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
     
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//        switch type {
//        case .insert:
//            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
//        case .delete:
//            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
//        case .move:
//            break
//        case .update:
//            break
//        @unknown default:
//            fatalError()
//        }
//    }
     
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            fatalError()
        }
    }
     
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedTransmissionService = self.fetchedResultsController.object(at: indexPath)

        self.performSegue(withIdentifier: "showTransmissionTorrentsTableViewController", sender: self)

        self.selectedTransmissionService = nil
    }

//    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
//        self.selectedTransmissionService = self.fetchedResultsController.object(at: indexPath)
//
//        self.performSegue(withIdentifier: "presentEditTransmissionServiceViewController", sender: self)
//
//        self.selectedTransmissionService = nil
//    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier) {
        case "presentaAddTransmissionServiceViewController":
            let transmissionServiceNavigationController = segue.destination as! UINavigationController
            let transmissionServiceViewController = transmissionServiceNavigationController.viewControllers.first as! AddTransmissionServiceViewController

            transmissionServiceViewController.managedObjectContext = self.fetchedResultsController.managedObjectContext

//        case "presentEditTransmissionServiceViewController":
//            let transmissionServiceNavigationController = segue.destination as! UINavigationController
//            let transmissionServiceViewController = transmissionServiceNavigationController.viewControllers.first as! EditTransmissionServiceViewController
//
//            transmissionServiceViewController.transmissionService = self.selectedTransmissionService

        case "showTransmissionTorrentsTableViewController":
            let transmissionTorrentsTableViewController = segue.destination as! TransmissionTorrentsTableViewController

            transmissionTorrentsTableViewController.managedObjectContext = self.managedObjectContext
            transmissionTorrentsTableViewController.transmissionService = self.selectedTransmissionService

        default:
            break
        }
    }

    @IBAction func unwindToTransmissionServicesTableViewController(segue: UIStoryboardSegue) { }

}
