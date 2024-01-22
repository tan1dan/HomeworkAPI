//
//  TableViewController.swift
//  HomeworkAPI
//
//  Created by Иван Знак on 22/01/2024.
//

import UIKit

class TableViewController: UIViewController {
    
    let tableView = UITableView()
    var users: [User]?
    var callback: (() -> [User])?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Users"
        navigationItem.setHidesBackButton(true, animated: false)
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "userCell")
        
        constraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let callback = callback {
            self.users = callback()
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
    
    func sendClosure(completion: @escaping () -> [User]) {
        self.callback = completion
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = users?.count else {return 0}
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        guard let users = self.users else { return cell }
        cell.textLabel?.text = "User: \(users[indexPath.row].id)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let userTableVC = UserTableViewController()
        userTableVC.sendUserClosure{ [weak self] in
            guard let users = self?.users else {return []}
            return users
        }
        userTableVC.sendIndexClosure { [weak self] in
            return index
        }
        navigationController?.pushViewController(userTableVC, animated: false)
    }
}
