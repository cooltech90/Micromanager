//
//  AddNewViewController.swift
//  ToDo
//
//  Created by Lourdes Zekkani on 5/26/21.
//

import UIKit
import CoreData

class AddNewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var text: UITextField!
    @IBAction func save(_ sender: Any) {
        save(name: text.text!)
        
        var specDel = ViewController()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getValues"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func exit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func save(name: String) {
      if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entityDescription =
          NSEntityDescription.entity(forEntityName: "Entity",
                                     in: context) else { return }
        
        
        let newValue = NSManagedObject(entity: entityDescription, insertInto: context)
        newValue.setValue(name, forKey: "info")
        
        do {
          try context.save()
            print("Saved: \(name)")
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
      }
      
    }

}
