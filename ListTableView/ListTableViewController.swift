//
//  ListTableViewController.swift
//  UserDefaults
//
//  Created by 김진형 on 2018. 8. 10..
//  Copyright © 2018년 JinHyeongKim. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    //MARK: property
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var married: UISwitch!
    
    var accountlist = [String]()
    var defaultPList : NSDictionary!
    
    //MARK: func-changeGender
    @IBAction func changeGender(_ sender: UISegmentedControl) {
        let value = sender.selectedSegmentIndex //0이면 남자, 1이면 여자
        
        let customPlist = "\(account.text!).plist"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        let plist = path.strings(byAppendingPaths: [customPlist]).first!
        
        let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultPList)
        
        data.setValue(value, forKey: "gender")
        data.write(toFile: plist, atomically: true)
    }
    
    //#MARK: func-chaneMarried
    @IBAction func changeMarried(_ sender: UISwitch) {
        let value = sender.isOn
        let customPlist = "\(account.text!).plist"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        let plist = path.strings(byAppendingPaths: [customPlist]).first!
        
        let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultPList)
        
        data.setValue(value, forKey: "married")
        data.write(toFile: plist, atomically: true)
    }
    
    
    //#MARK: func-pickerDone
    @objc func pickerDone(_ sender: Any) {
        self.view.endEditing(true)
        
        if let _account = self.account.text {
            let customPlist = "\(_account).plist"
            
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = paths[0] as NSString
            
            let clist = path.strings(byAppendingPaths: [customPlist]).first!
            
            let data = NSDictionary(contentsOfFile: clist)
            
            self.name.text = data?["name"] as? String
            self.gender.selectedSegmentIndex = data?["gender"] as? Int ?? 0
            self.married.isOn = data?["married"] as? Bool ?? false
        }
    }
    
    //#MARK: func-viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        if let defaultPListPath = Bundle.main.path(forResource: "UserInfo", ofType: "plist") {
            self.defaultPList = NSDictionary(contentsOfFile: defaultPListPath)
        }
        
        
        let plist = UserDefaults.standard

        account.borderStyle = .none
        
        let addBtn = UIBarButtonItem()
        addBtn.target = self
        addBtn.action = #selector(newAccount(_:))
        self.navigationItem.rightBarButtonItems = [addBtn]
        
        let picker = UIPickerView()
        picker.delegate = self
        self.account.inputView = picker
        
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: 0, width: 0, height: 35)
        toolBar.barTintColor = UIColor.lightGray
        self.account.inputAccessoryView = toolBar
        
        let done = UIBarButtonItem()
        done.title = "Done"
        done.target = self
        done.action = #selector(pickerDone)
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let new = UIBarButtonItem()
        new.title = "New"
        new.target = self
        new.action = #selector(newAccount(_:))
        
        toolBar.setItems([new,flexSpace, done], animated: true)
        //flexSpace Item을 배열의 어느 위치에 넣느냐에 따라 왼쪽, 오른쪽, 가운데 설정 가능
        
        let accountlist = plist.array(forKey: "accountlist") as? [String] ?? [String]()
        self.accountlist = accountlist
        
        if let account = plist.string(forKey: "selectedAccount") {
            self.account.text = account
            
            let customPlist = "\(self.account.text!).plist"
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = paths[0] as NSString
            let clist = path.strings(byAppendingPaths: [customPlist]).first!
            
            let data = NSDictionary(contentsOfFile: clist)
            
            self.name.text = data?["name"] as? String
            self.gender.selectedSegmentIndex = data?["gender"] as? Int ?? 0
            self.married.isOn = data?["married"] as? Bool ?? false
            
            
        }
        if (self.account.text?.isEmpty)! {
            self.account.placeholder = "등록된 계정이 없습니다."
            self.gender.isEnabled = false
            self.married.isEnabled = false
        }
    }
    
    
    //#MARK: func-newAccount
    @objc func newAccount(_ sender : Any) {
        self.view.endEditing(true)
        
        let alert = UIAlertController(title: "새 계정을 입력하세요", message: nil, preferredStyle: .alert)
        
        alert.addTextField() {
            $0.placeholder = "ex) abc@naver.com"
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            if let account = alert.textFields?[0].text {
                self.account.text = ""
                self.married.isOn = false
                self.gender.selectedSegmentIndex = 0
                
                self.accountlist.append(account)
                self.account.text = account
                
                let plist = UserDefaults.standard
                plist.set(self.accountlist, forKey: "accountlist")
                plist.set(account, forKey: "selectedAccount")
                plist.synchronize()
            }
        }
        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 && !(self.account.text?.isEmpty)! {
            let alert = UIAlertController(title: nil, message: "이름을 입력하세요.", preferredStyle: .alert)
            
            alert.addTextField() {
                //입력필드 추가
                $0.text = self.name.text
            }
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                let value = alert.textFields?[0].text
                
                let customPlist = "\(self.account.text!).plist"
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let path = paths[0] as NSString
                
                let plist = path.strings(byAppendingPaths: [customPlist]).first!
                let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultPList)
                
                data.setValue(value, forKey: "name")
                data.write(toFile: plist, atomically: true)
                
                self.name.text = value
                
                self.gender.isEnabled = true
                self.married.isEnabled = true
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    //#MARK : func-tableview-numberOfSections
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return super.numberOfSections(in: tableView)
    }
    
    
    
    //#MARK : func-tableview-numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
}


extension ListTableViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //How many Components
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.accountlist.count
    }
    
    
}

extension ListTableViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //Components Data
        return self.accountlist[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //action
        let account = self.accountlist[row]
        self.account.text = account
        
        let plist = UserDefaults.standard
        plist.set(account, forKey: "selectedAccount")
        plist.synchronize()
    }
}
