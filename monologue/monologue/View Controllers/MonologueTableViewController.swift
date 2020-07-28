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
    var category: MonologueCategory?
    var dateFormatter: DateFormatter?
    
    weak var delegate: MemoDelegate?
    
    lazy var fetchedResultsController: NSFetchedResultsController<Monologue> = {
        let fetchRequest: NSFetchRequest<Monologue> = Monologue.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        
        guard let category = category else {
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
        
        return frc
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let monologue = fetchedResultsController.sections?[section].numberOfObjects ?? 0
        delegate?.updateCount(with: monologue)
        return monologue
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.scriptCell, for: indexPath) as? MemoTableViewCell else {
            return UITableViewCell()
        }
        
        let monologue = fetchedResultsController.object(at: indexPath)
        cell.monologue = monologue
        cell.dateFormatter = dateFormatter
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let scriptDetailVC = storyboard?.instantiateViewController(identifier: Identifier.detailVC, creator: { coder in
            let monologue = self.fetchedResultsController.object(at: indexPath)
            guard let monologueController = self.monologueController,
                let dateFormatter = self.dateFormatter else {
                    fatalError("Information was never passed through view controllers")
            }
            
            return DetailsViewController(coder: coder,
                                             monologue: monologue,
                                             monologueController: monologueController,
                                             dateFormatter: dateFormatter)}) else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        navigationController?.pushViewController(scriptDetailVC, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let monologue = fetchedResultsController.object(at: indexPath)
            monologueController?.deleteMonologue(monologue)
            guard let count = fetchedResultsController.fetchedObjects?.count else { return }
            delegate?.updateCount(with: count)
            tableView.reloadData()
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
