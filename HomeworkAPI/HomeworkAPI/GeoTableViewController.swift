//
//  GeoTableViewController.swift
//  HomeworkAPI
//
//  Created by Иван Знак on 22/01/2024.
//

import UIKit

class GeoTableViewController: UIViewController {
    let tableView = UITableView()
    var users: [User]?
    var index: Int?
    var callbackUser: (() -> [User])?
    var callbackIndex: (() -> Int)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Geo"
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "userCell")
        
        constraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let callbackUser = callbackUser {
            self.users = callbackUser()
        }
        if let callbackIndex = callbackIndex {
            self.index = callbackIndex()
        }
    }
    
    private func constraints(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func sendUserClosure(completion: @escaping () -> [User]) {
        self.callbackUser = completion
    }
    
    func sendIndexClosure(completion: @escaping () -> Int) {
        self.callbackIndex = completion
    }
}

extension GeoTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        guard let users = self.users, let index = index else { return cell }
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Lat: \(users[index].address.geo.lat)"
            return cell
        case 1:
            cell.textLabel?.text = "Lng: \(users[index].address.geo.lng)"
            return cell
        
        default: return cell
        }
    }
}

