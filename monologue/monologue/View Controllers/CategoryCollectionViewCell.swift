//
//  CategoryCollectionViewCell.swift
//  monologue
//
//  Created by Nonye on 7/27/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
//    @IBOutlet weak var featuredImageBackground: UIImageView!
    
    
    var categoryImage: UIImageView!
    var categoryLabel: UILabel!
    
    var count = 0
    
    var monologues: [Monologue] = [] {
        didSet {
            updateUI()
        }
    }
    var categoryClass: Category! {
        didSet {
            updateUI()
        }
    }
    
    var category: MonologueCategory? {
        didSet {
            updateUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpSubviews()
    }
    
    private func setUpSubviews() {
        layer.cornerRadius = 10
        clipsToBounds = true
        categoryImage = UIImageView()
        categoryImage.contentMode = .scaleAspectFill
               categoryImage.translatesAutoresizingMaskIntoConstraints = false
               addSubview(categoryImage)

               NSLayoutConstraint.activate([
                   categoryImage.topAnchor.constraint(equalTo: topAnchor),
                   categoryImage.leadingAnchor.constraint(equalTo: leadingAnchor),
                   categoryImage.bottomAnchor.constraint(equalTo: bottomAnchor),
                   categoryImage.widthAnchor.constraint(equalTo: widthAnchor)
               ])
    }
    
    //    var category: Category! {
    //         didSet {
    //             updateUI()
    //         }
    //     }
//    #warning("This doesn't crash but suddendly my images are gone")
//    func updateUI() {
//        if let categoryClass = categoryClass {
//            featuredImageBackground.image = categoryClass.featuredImage
//        } else {
//            featuredImageBackground.image = nil
//        }
//    }
//}
//    func updateUI() {
//        if let categoryClass = categoryClass {
//            featuredImageBackground.image = categoryClass.featuredImage } else {
//            featuredImageBackground.image = nil
//        }
//        // ive tried a million and one things here, wrapping, unwrapping, forcing, switching it up
//        #warning("Not sure whats happening here but keeps crashing")
//        categoryImage.image = UIImage(named: category!.rawValue)
//        categoryLabel.text = category?.rawValue.capitalized
//    }
//}

    func updateUI() {
//        guard let categoryClass = categoryClass,
            guard let category = category else { return }
//        featuredImageBackground.image = categoryClass.featuredImage // -- lets try something new below
        categoryImage.image = UIImage(named: category.rawValue.lowercased())
        //        } else {
        //            featuredImageBackground.image = nil
        //            categoryImage.image = nil
        //            categoryLabel.text = nil
        }
        // ive tried a million and one things here, wrapping, unwrapping, forcing, switching it up
        #warning("Not sure whats happening here but keeps crashing")

//        categoryImage.image = UIImage(named: category?.rawValue)
//        categoryLabel.text = category?.rawValue.capitalized
//        categoryImage.layer.cornerRadius = 10.0
//        categoryImage.layer.masksToBounds = true
    
    }

