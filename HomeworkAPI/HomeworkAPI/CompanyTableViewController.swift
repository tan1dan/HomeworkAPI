//
//  CompanyTableViewController.swift
//  HomeworkAPI
//
//  Created by Иван Знак on 22/01/2024.
//

import UIKit

class CompanyTableViewController: UIViewController {
    let tableView = UITableView()
    var users: [User]?
    var index: Int?
    var callbackUser: (() -> [User])?
    var callbackIndex: (() -> Int)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Company"
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

extension CompanyTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        guard let users = self.users, let index = index else { return cell }
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Name: \(users[index].company.name)"
            return cell
        case 1:
            cell.textLabel?.text = "CatchPhrase: \(users[index].company.catchPhrase)"
            cell.textLabel?.numberOfLines = 0
            return cell
        case 2:
            cell.textLabel?.text = "Bs: \(users[index].company.bs)"
            return cell
        default: return cell
        }
    }
}

