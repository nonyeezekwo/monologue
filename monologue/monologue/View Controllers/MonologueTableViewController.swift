//
//  MonologueTableViewController.swift
//  monologue
//
//  Created by Nonye on 7/27/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import UIKit
import CoreData

class MonologueTableViewController: UITableViewController {
    
    var monologueController: MonologueController?
    var category: Category? {
        didSet {
            setUpFetchResultsController()
        }
    }
    
    var dateFormatter: DateFormatter?
    var monologueCountLabel: UILabel!
//    weak var delegate: MemoDelegate?
    var fetchedResultsController: NSFetchedResultsController<Monologue>?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setUpFetchResultsController() {
        let fetchRequest: NSFetchRequest<Monologue> = Monologue.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        
        guard let category = category?.monologueCategory else {
            fatalError("Category was never passed to TableViewController")
        }
        
        let predicate = NSPredicate(format: "category == %@", category.rawValue)
        fetchRequest.predicate = predicate
        
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch:\(error)")
        }
        
        self.fetchedResultsController = frc
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let monologues = fetchedResultsController?.sections?[section].numberOfObjects ?? 0
//        delegate?.updateCount(with: monologues)
        return monologues
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.memoCell, for: indexPath) as? MemoTableViewCell else {
            return UITableViewCell()
        }
        
        let monologue = fetchedResultsController?.object(at: indexPath)
        cell.monologue = monologue
        cell.dateFormatter = dateFormatter
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let monologue = fetchedResultsController?.object(at: indexPath) else { return }
            monologueController?.deleteMonologue(monologue)
            guard let count = fetchedResultsController?.fetchedObjects?.count else { return }
            //            delegate?.updateCount(with: count)
            tableView.reloadData()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailSegue" {
            if let detailVC = segue.destination as? DetailsViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                detailVC.monologue = fetchedResultsController!.object(at: indexPath)
                detailVC.monologueController = monologueController
            }
        }
    }
}


extension MonologueTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        let sectionSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(sectionSet, with: .automatic)
        case .delete:
            tableView.deleteSections(sectionSet, with: .automatic)
        default:
            return
        }
    }
}
