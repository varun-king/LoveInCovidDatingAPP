//
//  ViewController.swift
//  LoveInCovid
//
//  Created by Parrot on 2020-06-02.
//  Copyright © 2020 Parrot. All rights reserved.
//

import UIKit
import Alamofire

struct responseStruct:Codable {
    
    var response:String = ""
    var alternate:String?
    
    init() {}
}



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var chatMessages:[String] = []
    
    var menuData:[responseStruct] = []
    // ----------
    // MARK: Outlets
    // ----------
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var chatbox: UITextField!
    
    // ----------
    // MARK: IOS Lifecycle Functions
    // ----------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        
        // load the json file here
        guard let file = openFile() else { return }
        
         menuData = self.getData(from: file)!
        
        chatMessages.append(menuData[0].response)
        
    }
    
    
    @IBAction func sendMessage(_ sender: Any) {
        print("mesage sent")
        chatMessages.append("\(chatbox.text!)")
        chatbox.text = ""
        self.tableview.reloadData()
        if(chatMessages.count == 2){
           chatMessages.append(menuData[1].response)
        }else if(chatMessages.count == 4){
            chatMessages.append(menuData[2].response)
        }
         self.tableview.reloadData()
        
        self.tableview.reloadData()
        
    }
    
    // ----------
    // MARK: Table View Functions
    // ----------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = self.chatMessages[indexPath.row]
        return cell
    }

    
    
    func openDefaultFile()-> String? {
        guard let file = Bundle.main.path(forResource:"responses", ofType:"json") else {
            print("Cannot find file")
            return nil;
        }
        print("File found: \(file.description)")
        return file
    }
    func openFile() -> String? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let finalPath = paths[0]
        
        let filename = finalPath.appendingPathComponent("responses.json")
        
        // check if file exists
        let fileExists = FileManager().fileExists(atPath: filename.path)
        
        if (fileExists == true) {
            // load words from saved file
            return filename.path;
        }
        else {
            // open words from default file
            return self.openDefaultFile()
        }
        return nil
    }
    
    func getData(from file:String?) -> [responseStruct]? {
        if (file == nil) {
            print("File path is null")
            return nil
        }
        do {
            // open the file
            let jsonData = try String(contentsOfFile: file!).data(using: .utf8)
            print(jsonData)         // outputs: Optional(749Bytes)
            
            // get content of file
            let decodedData =
                try JSONDecoder().decode([responseStruct].self, from: jsonData!)
            
            // DEBUG: print file contents to screen
            dump(decodedData)
            
            return decodedData
        } catch {
            print("Error while parsing file")
            print(error.localizedDescription)
        }
        return nil
    }
    
    
    // ----------
    // MARK: Actions
    // ----------
   
}

