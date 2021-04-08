//
//  ViewController.swift
//  RandomlyChoose
//
//  Created by Josh Hubbard on 7/25/17.
//  Copyright © 2017 Josh Hubbard. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate {
    //    ★ or ☆
    
    /*
     UPDATES:
     - Now able to close out of load menu without loading a list
     - Added ☆ to indicate which item was chosen the most
     - Fixed issue where app became unresponsive when pressing load button with no saved lists
     - It is now possible to delete saved lists
     - Minor bugs fixed
     */
    
    /*
     TODO:
     
     - previous list entry not being cleared after clear list
     - can't save after canceling a load
     
     
     
     - add a default coin to load
     - add default die to load
        - give option to make the die go from 6-#
        - give option for how many dice to roll
     */
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var choiceLabel: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var customNumChoiceView: UIView!
    @IBOutlet weak var customNumTextField: UITextField!
    @IBOutlet weak var enterTitleView: UIView!
    @IBOutlet weak var enterTitle: UITextField!
    
    @IBOutlet weak var loadSaveView: UIView!
    
    @IBOutlet weak var saveLoadButton: RoundCornerButton!
    @IBOutlet weak var customNumDone: UIButton!
    @IBOutlet weak var enterBtn: RoundCornerButton!
    @IBOutlet weak var chooseOneBtn: RoundCornerButton!
    @IBOutlet weak var chooseTenBtn: RoundCornerButton!
    @IBOutlet weak var chooseXBtn: RoundCornerButton!
    @IBOutlet weak var clearBtn: RoundCornerButton!
    @IBOutlet weak var saveBtn: RoundCornerButton!
    
    var arrayList = [String]()
    var tempArrayList = [String]()
    var indexArray = [Int]()
    
    var previousListEntryArray = [String]()
    
    var listTitle = ""
    var titleArray = [String]()
    
    var loading = false
    
    var highestChosenIndex = 0
    var highestChosenNum = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userInput.delegate = self
        self.enterTitle.delegate = self
        
        self.table.delegate = self
        self.table.dataSource = self
        
        let request = GADRequest()
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-6720835517982104/8013316478"
        bannerView.rootViewController = self
        bannerView.load(request)
    }
    
    @IBAction func enterButtonPressed(_ sender: Any) {
        var newText = ""
        
        if userInput.hasText {
            newText = (userInput.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        }
            
        if newText != "" {
            if arrayList == tempArrayList {
                arrayList.append(newText)
                previousListEntryArray.append(newText)
                indexArray.append(0)
                tempArrayList = arrayList
            } else {
                arrayList = tempArrayList
                arrayList.append(newText)
                previousListEntryArray.append(newText)
                indexArray.append(0)
                tempArrayList = arrayList
            }
            
            userInput.text?.removeAll()
            table.reloadData()
        } else {
            choiceLabel.text = "Please enter text"
            
            delay(3.0) {
                self.choiceLabel.text?.removeAll()
            }
        }
        
        if tempArrayList.count >= 2 {
            saveLoadButton.isEnabled = true
            saveLoadButton.alpha = 1.0
        }
    }
    
    @IBAction func chooseX1ButtonPressed(_ sender: Any) {
        if arrayList.count > 1 {
            let randomIndex = Int(arc4random_uniform(UInt32(arrayList.count)))
            let randomItem = tempArrayList[randomIndex]
            
            for y in 0...(arrayList.count - 1) {
                
                arrayList[y] = tempArrayList[y]
                
                if arrayList[y] == randomItem {
                    arrayList[y] = randomItem + " ☆"
                }
                table.reloadData()
            }
            
            choiceLabel.text = "Your choice is: " + randomItem
        } else {
            choiceLabel.text = "Please enter more than one item to the list"
            
            delay(3.0) {
                self.choiceLabel.text?.removeAll()
            }
        }
    }
    
    @IBAction func chooseX10ButtonPressed(_ sender: Any) {
        choiceLabel.text?.removeAll()
        
        if arrayList.count > 1 {
            var count = 0
            var randomIndex = Int(arc4random_uniform(UInt32(arrayList.count)))
            var tempNum = 0
            
            for x in 0...(indexArray.count - 1) {
                indexArray[x] = 0
            }
            
            while count < 10 {
                randomIndex = Int(arc4random_uniform(UInt32(arrayList.count)))
                
                tempNum = indexArray[randomIndex] + 1
                
                indexArray.remove(at: randomIndex)
                indexArray.insert(tempNum, at: randomIndex)
                
                count += 1
            }
            
            for z in 0...(arrayList.count - 1) {
                if indexArray[highestChosenIndex] <= indexArray[z] {
                    highestChosenIndex = z
                    highestChosenNum = indexArray[z]
                }
            }
            
            for y in 0...(arrayList.count - 1) {
                if indexArray[y] == highestChosenNum {
                     arrayList[y] = "\(tempArrayList[y]): Chosen \(indexArray[y]) Times ☆"
                } else {
                    arrayList[y] = "\(tempArrayList[y]): Chosen \(indexArray[y]) Times"
                }
                
                table.reloadData()
            }
        } else {
            choiceLabel.text = "Please enter more than one item to the list"
            
            delay(3.0) {
                self.choiceLabel.text?.removeAll()
            }
        }
    }
    
    @IBAction func chooseXButtonPressed(_ sender: Any) {
        choiceLabel.text?.removeAll()
        
        if arrayList.count > 1 {
            customNumChoiceView.isHidden = false
            customNumTextField.text?.removeAll()
            customNumTextField.becomeFirstResponder()
            disableBtns()
        } else {
            choiceLabel.text = "Please enter more than one item to the list"
            
            delay(3.0) {
                self.choiceLabel.text?.removeAll()
            }
        }
    }
    
    @IBAction func customNumChoiceDone(_ sender: Any) {
        
        if arrayList.count > 1 {
            var count = 0
            var randomIndex = Int(arc4random_uniform(UInt32(arrayList.count)))
            var tempNum = 0
            customNumTextField.resignFirstResponder()
            
            for x in 0...(indexArray.count - 1) {
                indexArray[x] = 0
            }
            
            if customNumTextField.hasText {
                if Int(customNumTextField.text!)! > 9999999 || Int(customNumTextField.text!)! < 1 {
                    choiceLabel.text = "Please enter a number 1 - 9,999,999"
                    
                    delay(3.0) {
                        self.choiceLabel.text?.removeAll()
                    }
                } else {
                    while count < Int(customNumTextField.text!)! {
                        randomIndex = Int(arc4random_uniform(UInt32(arrayList.count)))
                        
                        tempNum = indexArray[randomIndex] + 1
                        
                        indexArray.remove(at: randomIndex)
                        indexArray.insert(tempNum, at: randomIndex)
                        
                        count += 1
                    }
                    
                    for z in 0...(arrayList.count - 1) {
                        if indexArray[highestChosenIndex] <= indexArray[z] {
                            highestChosenIndex = z
                            highestChosenNum = indexArray[z]
                        }
                    }
                    
                    for y in 0...(arrayList.count - 1) {
                        if indexArray[y] == highestChosenNum {
                            arrayList[y] = "\(tempArrayList[y]): Chosen \(indexArray[y]) Times ☆"
                        } else {
                            arrayList[y] = "\(tempArrayList[y]): Chosen \(indexArray[y]) Times"
                        }
                        
                        table.reloadData()
                    }
                }
            }
        }
        
        self.view.endEditing(true)
        customNumChoiceView.isHidden = true
        
        enableBtns()
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        if !loading {
            arrayList.removeAll()
            tempArrayList.removeAll()
            previousListEntryArray.removeAll()
            choiceLabel.text = "List Cleared"
            table.reloadData()
            
            delay(3.0) {
                self.choiceLabel.text?.removeAll()
            }
        } else {
            titleArray.removeAll()
            arrayList = previousListEntryArray
            tempArrayList = arrayList
            table.reloadData()
            table.allowsSelection = false
            
            choiceLabel.text?.removeAll()
            clearBtn.setTitle("Clear List", for: .normal)
            enableBtns()
            loading = false
        }
    }
    
    @IBAction func loadListBtnPressed(_ sender: Any) {
        if UserDefaults.standard.array(forKey: "title") != nil {
            
            table.allowsSelection = true
            
            titleArray = loadTitle()
            
            loadSaveView.isHidden = true
            
            tempArrayList = titleArray
            arrayList = titleArray
            table.reloadData()
            
            table.allowsSelection = true
            loading = true
            
            choiceLabel.text = "Select a list to load"
            disableBtns()
            
            clearBtn.isEnabled = true
            clearBtn.alpha = 1.0
            clearBtn.setTitle("Cancel", for: .normal)
            
            if titleArray.isEmpty {
                loadSaveView.isHidden = true
                choiceLabel.text = "No lists to be loaded"
                
                delay(3.0) {
                    self.choiceLabel.text?.removeAll()
                }
                enableBtns()
            }
        } else {
            loadSaveView.isHidden = true
            choiceLabel.text = "No lists to be loaded"
            
            delay(3.0) {
                self.choiceLabel.text?.removeAll()
            }
            enableBtns()
        }
    }
    
    @IBAction func saveListBtnPressed(_ sender: Any) {
        enterTitle.becomeFirstResponder()
        enterTitleView.isHidden = false
        loadSaveView.isHidden = true
    }
    
    @IBAction func saveLoadButtonPressed(_ sender: Any) {
        if tempArrayList.count < 2 {
            saveBtn.isEnabled = false
            saveBtn.alpha = 0.5
        } else {
            saveBtn.isEnabled = true
            saveBtn.alpha = 1.0
        }
        
        disableBtns()
        loadSaveView.isHidden = false
    }
    
    @IBAction func saveTitlePressed(_ sender: Any) {
        if enterTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            listTitle = "Title"
        } else {
            listTitle = (enterTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        }
        
        enterTitleView.isHidden = true
        enterTitle.resignFirstResponder()
        saveList()
        saveTitle()
        enableBtns()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        if !loadSaveView.isHidden {
            loadSaveView.isHidden = true
        } else if !enterTitleView.isHidden {
            enterTitleView.isHidden = true
            enterTitle.text?.removeAll()
            
            self.view.endEditing(true)
        }
        enableBtns()
    }
    
    func enableBtns() {
        enterBtn.isEnabled = true
        chooseOneBtn.isEnabled = true
        chooseTenBtn.isEnabled = true
        chooseXBtn.isEnabled = true
        clearBtn.isEnabled = true
        userInput.isEnabled = true
        
        saveLoadButton.isEnabled = true
        saveLoadButton.alpha = 1.0
        
        enterBtn.alpha = 1.0
        chooseOneBtn.alpha = 1.0
        chooseTenBtn.alpha = 1.0
        chooseXBtn.alpha = 1.0
        clearBtn.alpha = 1.0
        userInput.alpha = 1.0
    }
    
    func disableBtns() {
        enterBtn.isEnabled = false
        chooseOneBtn.isEnabled = false
        chooseTenBtn.isEnabled = false
        chooseXBtn.isEnabled = false
        clearBtn.isEnabled = false
        userInput.isEnabled = false
        
        saveLoadButton.isEnabled = false
        saveLoadButton.alpha = 0.5
        
        enterBtn.alpha = 0.5
        chooseOneBtn.alpha = 0.5
        chooseTenBtn.alpha = 0.5
        chooseXBtn.alpha = 0.5
        clearBtn.alpha = 0.5
        userInput.alpha = 0.5
    }
    
    func saveList() {
        var list = [[String]]()
        if UserDefaults.standard.array(forKey: "list") != nil {
            list = UserDefaults.standard.array(forKey: "list") as! [[String]]
        }
        
        list.append(tempArrayList)
        UserDefaults.standard.set(list, forKey: "list")
    }
    
    func loadList() -> [[String]] {
        return UserDefaults.standard.array(forKey: "list") as! [[String]]
    }
    
    func saveTitle() {
        var title = [String]()
        if UserDefaults.standard.array(forKey: "title") != nil {
            title = UserDefaults.standard.array(forKey: "title") as! [String]
        }
        
        title.append(listTitle)
        UserDefaults.standard.set(title, forKey: "title")
    }
    
    func loadTitle() -> [String] {
        return UserDefaults.standard.array(forKey: "title") as! [String]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"cell")
        cell.textLabel?.text = arrayList[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        cell.textLabel?.adjustsFontSizeToFitWidth = true

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if loading {
            if (editingStyle == UITableViewCellEditingStyle.delete) {
                if UserDefaults.standard.array(forKey: "title") != nil {
                    table.beginUpdates()
                    var tempListLoad = UserDefaults.standard.array(forKey: "list") as! [[String]]
                    
                    titleArray.remove(at: indexPath.row)
                    tempListLoad.remove(at: indexPath.row)
                    tempArrayList = titleArray
                    arrayList = titleArray
                    
                    UserDefaults.standard.set(titleArray, forKey: "title")
                    UserDefaults.standard.set(tempListLoad, forKey: "list")
                    UserDefaults.standard.synchronize()
                    table.deleteRows(at: [indexPath], with: .none)
                    
                    if titleArray.isEmpty {
                        choiceLabel.text?.removeAll()
                        enableBtns()
                    }
                    table.endUpdates()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if loading {
            var loadedList = loadList()
            arrayList = loadedList[indexPath.row]
            tempArrayList = arrayList
            
            var count = 0
            while count != tempArrayList.count {
                indexArray.append(0)
                
                count += 1
            }
            
            table.reloadData()
            
            table.allowsSelection = false
            loading = false
            
            choiceLabel.text?.removeAll()
            clearBtn.setTitle("Clear List", for: .normal)
            enableBtns()
        }
    }
}

