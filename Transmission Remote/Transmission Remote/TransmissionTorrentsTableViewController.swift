//
//  TransmissionTorrentsTableViewController.swift
//  Transmission Remote
//
//  Created by 👽 on 4/22/20.
//  Copyright © 2020 chead. All rights reserved.
//

import UIKit
import CoreData
import TransmissionKit

class TransmissionTorrentsTableViewController: UITableViewController , NSFetchedResultsControllerDelegate{
    var managedObjectContext: NSManagedObjectContext!
    var transmissionService: TransmissionService!

    private var transmissionClient: TransmissionKit.Client?

    lazy var fetchedResultsController: NSFetchedResultsController<TransmissionTorrent> = {
        let transissionServersFetchRequest: NSFetchRequest<TransmissionTorrent> = NSFetchRequest(entityName: "TransmissionTorrent")

        transissionServersFetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

        var fetchedResultsController = NSFetchedResultsController(fetchRequest: transissionServersFetchRequest,
                                                                  managedObjectContext: self.transmissionService.managedObjectContext!,
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

        self.transmissionService.refreshTorrents { (error) in }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "transmissionTorrentTableViewCell", for: indexPath)

        let transmissionTorrent = self.fetchedResultsController.object(at: indexPath)

        cell.textLabel?.text = transmissionTorrent.name

        return cell
    }

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


}