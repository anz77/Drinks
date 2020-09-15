//
//  FilterViewController.swift
//  Drinks
//
//  Created by Andrii Zuiok on 14.09.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    init(model: Model) {
        self.model = model
        self.model.editCategories = self.model.categories
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
   
    lazy var applyButton: UIButton = {
        var button = UIButton()
        button.setTitle("APPLY", for: UIControl.State.normal)
        button.setTitleColor(UIColor.systemBlue, for: UIControl.State.normal)
        button.backgroundColor = UIColor.systemFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(apply), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    @objc func apply() {
        
        self.model.saveChanges()
    }
    
    var model: Model

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    func setupUI() {
        
        self.view.addSubview(tableView)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0)
        ])
        
        self.view.addSubview(applyButton)
    
        NSLayoutConstraint.activate([
            applyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            applyButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            applyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            applyButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }

}


extension FilterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        self.model.editCategories?[indexPath.row].isActive.toggle()
        
        if let category = self.model.editCategories?[indexPath.row] {
            cell?.accessoryType = category.isActive ? .checkmark : .none
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension FilterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = self.model.categories?[indexPath.row].name
        
        if let category = self.model.editCategories?[indexPath.row] {
             cell.accessoryType = category.isActive ? .checkmark : .none
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}



