//
//  ViewController.swift
//  ToDo
//
//  Created by Lourdes Zekkani on 5/26/21.
//

import UIKit
import CoreData

var todoCells = [String()]
var todoCellsDelete = [NSManagedObject()]

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var todoList: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let currentDateTime = Date()

        // get the user's calendar
        let userCalendar = Calendar.current

        // choose which date and time components are needed
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day
        ]

        // get the components
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)

        // now the components are available
        dateTimeComponents.year   // 2016
        dateTimeComponents.month  // 10
        dateTimeComponents.day    // 8
        
        
        var month = ""
        switch dateTimeComponents.month! {
        case 1:
            month = "Jan"
        case 2:
            month = "Feb"
        case 3:
            month = "Mar"
        case 4:
            month = "Apr"
        case 5:
            month = "May"
        case 6:
            month = "June"
        case 7:
            month = "July"
        case 8:
            month = "Aug"
        case 9:
            month = "Sep"
        case 10:
            month = "Oct"
        case 11:
            month = "Nov"
        case 12:
            month = "Dec"
        default:
            month = String(dateTimeComponents.month!)
        }
        
        var todaysDate = String(dateTimeComponents.day!) + " " + month + ", " + String(dateTimeComponents.year!)
        
        self.title = todaysDate
        
        getValues()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshWeatherData_ViewController(_:)), name: NSNotification.Name(rawValue: "getValues"), object: nil)
        
        if #available(iOS 10.0, *) {
            todoList.refreshControl = refreshControl
        } else {
            todoList.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        
    }
    
    

    @objc private func refreshWeatherData(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            
            todoCells.removeAll()
            todoCellsDelete.removeAll()

            self.getValues()
            self.refreshControl.endRefreshing()
        }
    }

    @objc private func refreshWeatherData_ViewController(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            
            todoCells.removeAll()
            todoCellsDelete.removeAll()

            self.getValues()
        }
    }
    
    
    @IBAction func AddNewTask(_ sender: Any) {
        performSegue(withIdentifier: "addSeg", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
          
            
            deleteData(name: todoCellsDelete[indexPath.row])
            
            
            todoCells.remove(at: indexPath.row)
            todoList.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todoList.deselectRow(at: indexPath, animated: true)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            // Configure the cell...
        
        cell.textLabel?.text = todoCells[indexPath.row]
            
        return cell
    }
    
    

}



extension ViewController {
    
    
    func getValues(){
        
        todoCells.removeAll()
        todoCellsDelete.removeAll()
        var everythingForWatch = ""
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Entity>(entityName: "Entity")
            
            do {
                let results = try context.fetch(fetchRequest)
                for result in results {
                    print("ENTINTY \(result)")
                    if let testValue = result.info {
                        todoCells.append(testValue)
                        self.todoList.reloadData()
                        
                        print(todoCells)
                    }
                }
                
                
                for items in results as! [NSManagedObject] {
                    todoCellsDelete.append(items)
                }
                
            } catch let error as NSError {
              print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        
    }
    
    
    
    func deleteData(name: NSManagedObject) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest =
              NSFetchRequest<Entity>(entityName: "Entity")
            
            do {
                try context.delete(name)
                do {
                    try context.save()
                } catch {
                    print(error)
                }
            } catch let error as NSError {
              print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        
    }
    
}
