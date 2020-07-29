//
//  CategoryViewController.swift
//  monologue
//
//  Created by Nonye on 7/27/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    #warning("Need to figure this out cause I need to be able to fetch the category images")
//    var categories = Category.fetchCategories()
    
    var categories = Category.fetchCategories()
//    var categories = Category.allCases
    
    //    var categories = [Category]()
    //var categories = [Category]()
    var monologueController = MonologueController()
    
//    let category: MonologueCategory
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifier.addRecording {
            if let destinationVC = segue.destination as? RecordViewController {
                destinationVC.monologueController = monologueController
                
            }
        } else if segue.identifier == Identifier.showMemos {
            if let destinationVC = segue.destination as? MonologueTableViewController,
                let indexPath = collectionView.indexPathsForSelectedItems?.first {
                destinationVC.category = Category.fetchCategories()[indexPath.row]
                destinationVC.monologueController = monologueController
                destinationVC.dateFormatter = dateFormatter
                //                destinationVC.delegate = self
            }
    
        }
    }
}


#warning ("must complete")
extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        
        let category = categories[indexPath.item]
        let monologues = monologueController.monologues
        cell.category = category.monologueCategory
        cell.monologues = monologues
        return cell
    }
}

extension CategoryViewController: UIScrollViewDelegate, UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        
        targetContentOffset.pointee = offset
    }
}
