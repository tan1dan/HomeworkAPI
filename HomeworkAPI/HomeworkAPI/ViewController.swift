//
//  ViewController.swift
//  HomeworkAPI
//
//  Created by Иван Знак on 21/01/2024.
//

import UIKit

enum NotificationStorage {
    static let notificationName = NSNotification.Name.init("usersInfo")
}

struct Geo: Codable {
    let lat: String
    let lng: String
    
    enum CodingKeys: CodingKey {
        case lat
        case lng
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lat = try container.decode(String.self, forKey: .lat)
        self.lng = try container.decode(String.self, forKey: .lng)
    }
}

struct Addres: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo
    
    enum CodingKeys: CodingKey {
        case street
        case suite
        case city
        case zipcode
        case geo
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.street = try container.decode(String.self, forKey: .street)
        self.suite = try container.decode(String.self, forKey: .suite)
        self.city = try container.decode(String.self, forKey: .city)
        self.zipcode = try container.decode(String.self, forKey: .zipcode)
        self.geo = try container.decode(Geo.self, forKey: .geo)
    }
}

struct Company: Codable {
    let name: String
    let catchPhrase: String
    let bs: String
    
    enum CodingKeys: CodingKey {
        case name
        case catchPhrase
        case bs
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.catchPhrase = try container.decode(String.self, forKey: .catchPhrase)
        self.bs = try container.decode(String.self, forKey: .bs)
    }
}

struct User: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Addres
    let phone: String
    let website: String
    let company: Company
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case username
        case email
        case address
        case phone
        case website
        case company
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.username = try container.decode(String.self, forKey: .username)
        self.email = try container.decode(String.self, forKey: .email)
        self.address = try container.decode(Addres.self, forKey: .address)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.website = try container.decode(String.self, forKey: .website)
        self.company = try container.decode(Company.self, forKey: .company)
    }
}

class ViewController: UIViewController {
    
    var users: [User] = []
    let loadingView = LoadingView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        saveUsers()
        constraintsLoading()
    }
    
    private func saveUsers(){
        DispatchQueue.global().sync {
            if let url = URL(string: "https://jsonplaceholder.typicode.com/users"){
                let urlRequest = URLRequest(url: url)
                let session = URLSession.shared
                let dataTask = session.dataTask(with: urlRequest) {
                    data,
                    response,
                    error in
                    if error == nil {
                        if let data = data{
                            
                            do {
                                if let jsonString = String(data: data, encoding: .utf8) {
                                    print("JSON-строка: \(jsonString)")
                                }
                                
                                let users = try JSONDecoder().decode([User].self, from: data)
    
                                self.users = users
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    let tableVC = TableViewController()
                                    tableVC.sendClosure { [weak self] in
                                        return users
                                    }
                                    self.navigationController?.setNavigationBarHidden(false, animated: false)
                                    self.navigationController?.pushViewController(tableVC, animated: false)
                                    self.navigationController?.viewControllers.first?.removeFromParent()
                                }
                            } catch let error{
                                print(error)
                            }
                            do {
                                if let dict = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [Any] {
                                    
                                    for user in dict {
                                        print("dict \(user)")
                                    }
                                }
                                
                            } catch let error {
                                print(error)
                            }
                            
                        } else {
                            print("Data == nil")
                            return
                        }
                    }else {
                        print("Error urlRequest")
                        return
                    }
                }
                dataTask.resume()
            }
        }
    }
    
    private func constraintsLoading(){
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }

}

