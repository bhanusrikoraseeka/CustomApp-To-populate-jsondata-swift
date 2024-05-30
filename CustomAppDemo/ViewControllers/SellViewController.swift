//
//  SellViewController.swift
//  CustomAppDemo
//
//  Created by Eficens on 18/10/22.
//

import UIKit
import CoreData
class SellViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var sellTableView: UITableView!
   
    private var models = [Devices]()
        override func viewDidLoad() {
            super.viewDidLoad()
            sellTableView.delegate = self
            sellTableView.dataSource = self
           
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            appDelegate.saveContext()
            self.sellTableView.reloadData()
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let vc = storyboard?.instantiateViewController(identifier: "ViewController") as? SellViewController
            
            navigationController?.pushViewController(vc!, animated: true)
        }
         
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return models.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for : indexPath) as! SellTableViewCell
            
            let devices = models[indexPath.row]
            cell.objectName.text = devices.names
            cell.objectPrice.text = "\(devices.prices)"
            cell.objectQuantity.text = "\(devices.quantities)"
            return cell
        }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ViewController"{
                if (self.sellTableView.indexPathForSelectedRow != nil) {
                    let vc = segue.destination as! SellViewController
                    
                    DispatchQueue.main.async {
                        self.sellTableView.reloadData()
                   }
                }
            }
           
            // To Create data
            func createData() {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let managedContext = appDelegate.persistentContainer.viewContext
                let Device = NSEntityDescription.entity(forEntityName: "Devices", in: managedContext)!
            
                for i in 1...3 {
                    
                    let device = NSManagedObject(entity: Device, insertInto: managedContext)
                    device.setValue("Table\(i)", forKey: "names")
                    device.setValue("12000\(i)", forKey: "prices")
                    device.setValue("1\(i)", forKey: "quantities")
                }
                do {
                    try managedContext.save()
                }
                catch  let error as NSError {
                    print("Could not save.\(error), \(error.userInfo)")
                }
                self.sellTableView.reloadData()
            }

            // To retrieve data
            func retrieveData() {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let managedContext = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Devices")
                fetchRequest.fetchLimit = 1
                fetchRequest.predicate = NSPredicate(format: "names = %@", "Table")
                fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "prices", ascending: false)]
                
                do {
                    let result = try managedContext.fetch(fetchRequest)
                    for data in result as! [NSManagedObject] {
                        print(data.value(forKey: "names") as! String)
                    }
                } catch {
                    print("Failed")
                }
                self.sellTableView.reloadData()
            }
            
            // To Update data
            func updateData() {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let managedContext = appDelegate.persistentContainer.viewContext
                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Devices")
                fetchRequest.predicate = NSPredicate(format: "names = %@", "Tv")
                do {
                    let test = try managedContext.fetch(fetchRequest)
                    
                    let deviceUpdate = test[0] as! NSManagedObject
                    deviceUpdate.setValue("newName", forKey: "names")
                    deviceUpdate.setValue("newPrice", forKey: "prices")
                    deviceUpdate.setValue("newQuantity", forKey: "quantities")
                    do {
                        try managedContext.save()
                    }
                    catch {
                        print(error)
                    }
                }
                catch{
                    print(error)
                }
            }
            
            // To Delete data
            func deleteData() {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let managedContext = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Devices")
                fetchRequest.predicate = NSPredicate(format: "names = %@", "iphone")
                do {
                    let test = try managedContext.fetch(fetchRequest)
                    
                    let objectTodelete = test[0] as! NSManagedObject
                    managedContext.delete(objectTodelete)
                    do{
                        try managedContext.save()
                    }
                    catch {
                        print(error)
                    }
                }
                catch {
                    print(error)
                }
            }
        }
    }

