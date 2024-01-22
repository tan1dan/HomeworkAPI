//
//  UserTableViewController.swift
//  HomeworkAPI
//
//  Created by Иван Знак on 22/01/2024.
//

import UIKit

class UserTableViewController: UIViewController {
    
    let tableView = UITableView()
    var users: [User]?
    var index: Int?
    var callbackUser: (() -> [User])?
    var callbackIndex: (() -> Int)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Information"
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

extension UserTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        guard let users = self.users, let index = index else { return cell }
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Id: \(users[index].id)"
            return cell
        case 1:
            cell.textLabel?.text = "Name: \(users[index].name)"
            return cell
        case 2:
            cell.textLabel?.text = "Username: \(users[index].username)"
            return cell
        case 3:
            cell.textLabel?.text = "Email: \(users[index].email)"
            
            return cell
        case 4:
            cell.textLabel?.text = "Address"
            cell.accessoryType = .disclosureIndicator
            return cell
        case 5:
            cell.textLabel?.text = "Phone: \(users[index].phone)"
            return cell
        case 6:
            cell.textLabel?.text = "Website: \(users[index].website)"
            return cell
        case 7:
            cell.textLabel?.text = "Company"
            cell.accessoryType = .disclosureIndicator
            return cell
        default: return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            let addressTableVC = AddressTableViewController()
            addressTableVC.sendUserClosure{ [weak self] in
                guard let users = self?.users else {return []}
                return users
            }
            addressTableVC.sendIndexClosure { [weak self] in
                guard let index = self?.index else {return 100}
                return index
            }
            navigationController?.pushViewController(addressTableVC, animated: false)
        }
        else if indexPath.row == 7 {
            let companyTableVC = CompanyTableViewController()
            companyTableVC.sendUserClosure{ [weak self] in
                guard let users = self?.users else {return []}
                return users
            }
            companyTableVC.sendIndexClosure { [weak self] in
                guard let index = self?.index else {return 100}
                return index
            }
            navigationController?.pushViewController(companyTableVC, animated: false)
        }
    }
}

