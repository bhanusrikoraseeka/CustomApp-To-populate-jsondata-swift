//
//  CallViewController.swift
//  CustomAppDemo
//
//  Created by Eficens on 18/10/22.
//

import UIKit

class CallViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var table : UITableView!
    var users: [User] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        
        
        let url =  "https://my-json-server.typicode.com/imkhan334/demo-1/call"
        getData(from: url)
        
    }
      
    private func getData(from url: String) {
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else{
                print("something went wrong")
                return
            }
            // have data
            var result: [User]?
            do{
                result =  try JSONDecoder().decode([User].self, from: data)
            }
            catch {
                print("failed to convert \(error.localizedDescription)")
            }
            
            self.users = result ?? []
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        })
        .resume()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ViewController"{
                if (self.table.indexPathForSelectedRow != nil) {
                    _ = segue.destination as! CallViewController
                }
            }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(identifier: "ViewController") as? ViewController
        
        navigationController?.pushViewController(vc!, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CallTableViewCell
        let user = users[indexPath.row]
        cell.nameLabel.text = user.name
        cell.numberLabel.text = user.number
        return cell
}
    
}
struct User: Codable {
    let id: Int  
    let name: String
    let number: String
}
