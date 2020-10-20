//
//  MainViewController.swift
//  Drinks
//
//  Created by Andrii Zuiok on 14.09.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import UIKit

protocol MainViewControllerProtocol: class {
    func didFetchData()
}

class MainViewController: UIViewController {
    
    var presenter: MainPresenterProtocol?
    
    lazy var tableView = makeTableView()

    init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewController = self
        
        self.setupUI()
        
        navigationItem.title = "Drinks"
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.filter))
    }
    
    @objc func filter() {
        presenter?.filterCategories()
    }
    
}


extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header")
        let headerView = UITableViewHeaderFooterView(reuseIdentifier: "Header")
        let label = UILabel()
        label.text = self.presenter?.drinksArray[section].name
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: headerView.contentView.leadingAnchor, constant: 15),
            label.heightAnchor.constraint(equalToConstant: 30),])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let drinks = presenter?.drinksArray[indexPath.section].drinks else {return}
        switch indexPath.row {
        case drinks.count - 1:
            self.presenter?.downloadNextAfter(currentSection: indexPath.section)
        case 0:
            self.presenter?.downloadPreviousBefore(currentSection: indexPath.section)
        default:
            break
        }
    }
    
}


extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter?.drinksArray[section].drinks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.nameLabel.text = presenter?.drinksArray[indexPath.section].drinks?[indexPath.row].name
        presenter?.getImageForIndexPath(indexPath: indexPath) { cell.display(image: $0) }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let presenter = presenter {
            return presenter.drinksArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.endDisplayingCellAt(indexPath: indexPath)
    }
    
    
}

extension MainViewController: MainViewControllerProtocol {
    func didFetchData() {
        self.tableView.reloadData()
    }
}


extension MainViewController {
    func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
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
    }
}
