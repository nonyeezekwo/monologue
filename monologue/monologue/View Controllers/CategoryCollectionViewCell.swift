//
//  CategoryCollectionViewCell.swift
//  monologue
//
//  Created by Nonye on 7/27/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    var categoryImage: UIImageView!
    var categoryLabel: UILabel!
    var count = 0
    
    var monologues: [Monologue] = [] {
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
    
    func updateUI() {
        guard let category = category else { return }
        categoryImage.image = UIImage(named: category.rawValue.lowercased())
    }
}
