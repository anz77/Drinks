//
//  TableVIewCell.swift
//  Drinks
//
//  Created by Andrii Zuiok on 14.09.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var onReuse: ()->Void = {}
    
    let drinkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(drinkImageView)
        NSLayoutConstraint.activate([
            drinkImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            drinkImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            drinkImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            drinkImageView.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 90),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])
        
    }
 
    
    override func prepareForReuse() {
      drinkImageView.image = nil
      drinkImageView.cancelImageLoad()
    }
}

