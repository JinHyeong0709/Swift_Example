//
//  ListTableViewController.swift
//  UserDefaults
//
//  Created by 김진형 on 2018. 8. 10..
//  Copyright © 2018년 JinHyeongKim. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var married: UISwitch!
    
    var accountlist = [ "asdfa@naver.com",
                        "12345@naver.com",
                        "abc1@daum.net",
                        "bcd2@gamil.com"]
    
    
    
    @IBAction func changeGender(_ sender: UISegmentedControl) {
        let value = sender.selectedSegmentIndex //0이면 남자, 1이면 여자
        let plist = UserDefaults.standard
        
        
        switch value {
        case 0:
            plist.set(value, forKey: "gender")
        case 1:
            plist.set(value, forKey: "gender")
        default:
            return
        }
        
        plist.synchronize()
    }
    
    @IBAction func changeMarried(_ sender: UISwitch) {
        let value = sender.isOn
        let plist = UserDefaults.standard
        
        plist.set(value, forKey: "marrid")
        plist.synchronize()
    }
    
    @objc func pickerDone(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        account.borderStyle = .none
        
        
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
        
        
    }
    
    @objc func newAccount(_ sender : Any) {
        self.view.endEditing(true)
        
        let alert = UIAlertController(title: "새 계정을 입력하세요", message: nil, preferredStyle: .alert)
        
        alert.addTextField() {
            $0.placeholder = "ex) abc@naver.com"
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            if let account = alert.textFields?[0].text {
                self.accountlist.append(account)
                self.account.text = account
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
        if indexPath.row == 1 {
            let alert = UIAlertController(title: nil, message: "이름을 입력하세요.", preferredStyle: .alert)
            
            alert.addTextField() {
                //입력필드 추가
                $0.text = self.name.text
            }
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                let value = alert.textFields?[0].text
                
                let plist = UserDefaults.standard
                plist.set(value, forKey:"name")
                plist.synchronize()
                
                self.name.text = value
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return super.numberOfSections(in: tableView)
    }
    
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
    }
}
