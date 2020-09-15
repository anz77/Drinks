//
//  ViewController.swift
//  Drinks
//
//  Created by Andrii Zuiok on 14.09.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ModelFetchDataDelegate {
    
    
    //let imageCache = NSCache<NSString, UIImage>()
    
    func didFetchData() {
        self.tableView.reloadData()
    }
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let model: Model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.delegate = self
        
        self.setupUI()
        
    }
    
    func setupUI() {
        
        self.view.addSubview(tableView)
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        navigationItem.title = "Drinks"
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItem.Style.plain, target: self, action: #selector(filter))
        
    }
    
    @objc func filter() {
        let filterViewController = FilterViewController(model: self.model)
        self.navigationController?.pushViewController(filterViewController, animated: true)
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header")
        
        let headerView = UITableViewHeaderFooterView(reuseIdentifier: "Header")
        
        let label = UILabel()
        label.text = self.model.drinksArray.filter({ $0.isVisible }).filter({ drinks in
            if let drinksItems = drinks.drinks {
                return !drinksItems.isEmpty
            }
            return false
            
        })[section].categoryName
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: headerView.contentView.leadingAnchor, constant: 15),
            label.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let drinks = model.drinksArray[indexPath.section].drinks else {return}
        
        if indexPath.row == drinks.count - 1 {
            self.model.downloadNextAfter(currentIndex: indexPath.section)
            //let nextIndex = self.model
        }
        
    }
    
}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.drinksArray.filter({ $0.isVisible }).filter({ drinks in
            if let drinksItems = drinks.drinks {
                return !drinksItems.isEmpty
            }
            return false
            
        }) [section].drinks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        cell.nameLabel.text = model.drinksArray.filter({ $0.isVisible })[indexPath.section].drinks?[indexPath.row].name
        
        if let thumb = self.model.drinksArray.filter({ $0.isVisible })[indexPath.section].drinks?[indexPath.row].thumb, let imageUrl = URL(string: thumb) {
            cell.drinkImageView.loadImage(at: imageUrl)
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print(self.model.drinksArray.filter({ $0.isVisible }).count)
        return self.model.drinksArray.filter({ $0.isVisible }).filter({ drinks in
            if let drinksItems = drinks.drinks {
                return !drinksItems.isEmpty
            }
            return false
        }).count
    }
}
