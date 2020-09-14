//
//  TransmissionServiceTableViewController.swift
//  Transmission Remote
//
//  Created by 👽 on 4/22/20.
//  Copyright © 2020 chead. All rights reserved.
//

import UIKit
import CoreData
import TransmissionKit

class TransmissionServiceTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var transmissionService: TransmissionService!

    let searchController = UISearchController(searchResultsController: nil)

    private var filteredTransmissionTorrents: [TransmissionTorrent] = []

    private var isFiltering: Bool { return searchController.isActive && !isSearchBarEmpty }

    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }

    lazy var fetchedResultsController: NSFetchedResultsController<TransmissionTorrent> = {
        let transmissionTorrentsFetchRequest: NSFetchRequest<TransmissionTorrent> = NSFetchRequest(entityName: "TransmissionTorrent")

        transmissionTorrentsFetchRequest.predicate = NSPredicate(format: "service == %@", self.transmissionService)

        transmissionTorrentsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

        var fetchedResultsController = NSFetchedResultsController(fetchRequest: transmissionTorrentsFetchRequest,
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

        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search Titles"

        self.navigationItem.searchController = searchController

        self.definesPresentationContext = true

        self.transmissionService.refreshTorrents() {}
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections!.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.isFiltering) {
            return self.filteredTransmissionTorrents.count
        } else {
            return self.fetchedResultsController.sections![section].numberOfObjects
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transmissionTorrentTableViewCell", for: indexPath) as! TransmissionTorrentsTableViewCell

        let transmissionTorrent: TransmissionTorrent

        if(isFiltering) {
            transmissionTorrent = self.filteredTransmissionTorrents[indexPath.row]
        } else {
            transmissionTorrent = self.fetchedResultsController.object(at: indexPath)
        }

        cell.title.text = transmissionTorrent.name

        return cell
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        @unknown default:
            fatalError()
        }
    }

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

    func filterTorrentsByTitle(title: String) {
        guard let fetchedObjects = self.fetchedResultsController.fetchedObjects else { return }

        self.filteredTransmissionTorrents = fetchedObjects.filter({ (transmissionTorrent) -> Bool in
            return transmissionTorrent.name.lowercased().contains(title.lowercased())
        })

        tableView.reloadData()
    }

}

extension TransmissionServiceTableViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = self.searchController.searchBar

    self.filterTorrentsByTitle(title: searchBar.text!)
  }

}
