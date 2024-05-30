//
//  BuyViewController.swift
//  CustomAppDemo
//
//  Created by Eficens on 18/10/22.
//

import UIKit

class BuyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var buytable: UITableView!
    var items: [Buyer] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        buytable.dataSource = self
        buytable.delegate = self
        
        let url =  "https://my-json-server.typicode.com/imkhan334/demo-1/buy"
        getData(from: url)
    }
    private func getData(from url: String) {
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else{
                print("something went wrong")
                return
            }
            // have data
            var result: [Buyer]?
            do{
                result =  try JSONDecoder().decode([Buyer].self, from: data)
            }
            catch {
                print("failed to convert \(error.localizedDescription)")
            }
            
            self.items = result ?? []
            DispatchQueue.main.async {
                self.buytable.reloadData()
            }
        })
        .resume()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewController"{
            if (self.buytable.indexPathForSelectedRow != nil) {
                _ = segue.destination as! BuyViewController
                }
            }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(identifier: "ViewController") as? BuyViewController
        
        navigationController?.pushViewController(vc!, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)as! BuyTableViewCell
        let item = items[indexPath.row]
        cell.namelabel.text = item.name
        cell.pricelabel.text = "\(item.price)"
        cell.quantitylabel.text = "\(item.quantity)"
        return cell
    }
}

    struct Buyer: Codable {
        let id: Int
        let name: String
        let price: Int
        let quantity: Int
        let type: Int
    }


