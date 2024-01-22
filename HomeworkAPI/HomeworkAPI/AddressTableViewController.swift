//
//  AddressTableViewController.swift
//  HomeworkAPI
//
//  Created by Иван Знак on 22/01/2024.
//

import UIKit

class AddressTableViewController: UIViewController {
    let tableView = UITableView()
    var users: [User]?
    var index: Int?
    var callbackUser: (() -> [User])?
    var callbackIndex: (() -> Int)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Address"
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

extension AddressTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        guard let users = self.users, let index = index else { return cell }
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "City: \(users[index].address.city)"
            return cell
        case 1:
            cell.textLabel?.text = "Geo"
            cell.accessoryType = .disclosureIndicator
            return cell
        case 2:
            cell.textLabel?.text = "Street: \(users[index].address.street)"
            return cell
        case 3:
            cell.textLabel?.text = "Suite: \(users[index].address.suite)"
            return cell
        case 4:
            cell.textLabel?.text = "Zipcode: \(users[index].address.zipcode)"
            return cell
        default: return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let geoTableVC = GeoTableViewController()
            geoTableVC.sendUserClosure{ [weak self] in
                guard let users = self?.users else {return []}
                return users
            }
            geoTableVC.sendIndexClosure { [weak self] in
                guard let index = self?.index else {return 100}
                return index
            }
            navigationController?.pushViewController(geoTableVC, animated: false)
        }
    }
}
