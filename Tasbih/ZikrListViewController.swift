//
//  ZikrListViewController.swift
//  Tasbih
//
//  Created by Sugirbay Margulan on 4/16/20.
//  Copyright © 2020 Sugirbay Margulan. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift

protocol MyDataSendingDelegateProtocol {
    func sendDataToFirstViewController(zikrFromList: Zikir, zikirIndexPath: Int)
}

class ZikrListViewController: UIViewController, UIGestureRecognizerDelegate {

    let realm = try! Realm()
    var zikirArray:Results<Zikir>!
    var delegate: MyDataSendingDelegateProtocol? = nil
    
    var navBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        let navItem = UINavigationItem(title: "Зікірлер")
        let doneItem = UIBarButtonItem(title: "Кері", style: .done, target: nil, action: #selector(donePressed))
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: #selector(addPressed))
        let textAttributes = [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
        navigationBar.titleTextAttributes = textAttributes
        navItem.leftBarButtonItem = doneItem
        navItem.rightBarButtonItem = addItem
        navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationBar.setItems([navItem], animated: false)
        navigationBar.isTranslucent = false
        navigationBar.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return navigationBar
    }()
    
    var tableView = UITableView()
    
    var transparentView: UIView = {
       let view = UIView()
       view.isHidden = true
       view.backgroundColor = UIColor(white: 0.9, alpha: 0.6)
       return view
    }()
    
    var addNewZikrView:UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.layer.cornerRadius = 10
        view.layer.borderColor = #colorLiteral(red: 0.8823529412, green: 0.8980392157, blue: 0.9215686275, alpha: 1)
        view.layer.borderWidth = 2
        view.layer.masksToBounds = true
        return view
    }()
    
    var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "close")
        let resizedImage = image?.resized(to: CGSize(width: 25, height: 25))
        button.setImage(resizedImage, for: .normal)
        button.tintColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        button.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        return button
    }()
    
    var addZikrLabel: UILabel = {
        let label = UILabel()
        label.text = "Жаңа зікір қосыңыз"
        label.font = UIFont.systemFont(ofSize: 25, weight: .light)
        label.textColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        return label
    }()
    
    var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Бос орынды толтырыңыз"
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = .red
        label.isHidden = true
        return label
    }()
    
    var zikrNameTF: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Зікір атауы *",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)])
        textField.font = UIFont.systemFont(ofSize: 16, weight: .light)
        textField.borderStyle = .none
        textField.returnKeyType = UIReturnKeyType.done
        textField.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.6274509804, green: 0.6745098039, blue: 0.7411764706, alpha: 1), width: 1.5)
        textField.setLeftPaddingPoints(4)
        return textField
    }()
    
    var zikrTranscriptTF: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Транскрипт",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)])
        textField.font = UIFont.systemFont(ofSize: 16, weight: .light)
        textField.borderStyle = .none
        textField.returnKeyType = UIReturnKeyType.done
        textField.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.6274509804, green: 0.6745098039, blue: 0.7411764706, alpha: 1), width: 1.5)
        textField.setLeftPaddingPoints(4)
        return textField
    }()
    
    var zikrArabTF: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Арабша жазылуы",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)])
        textField.font = UIFont.systemFont(ofSize: 16, weight: .light)
        textField.borderStyle = .none
        textField.returnKeyType = UIReturnKeyType.done
        textField.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.6274509804, green: 0.6745098039, blue: 0.7411764706, alpha: 1), width: 1.5)
        textField.setLeftPaddingPoints(4)
        return textField
    }()
    
    var zikrMeaningTF: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Мағынасы *",
        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)])
        textField.font = UIFont.systemFont(ofSize: 16, weight: .light)
        textField.borderStyle = .none
        textField.returnKeyType = UIReturnKeyType.done
        textField.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.6274509804, green: 0.6745098039, blue: 0.7411764706, alpha: 1), width: 1.5)
        textField.setLeftPaddingPoints(4)
        return textField
    }()
    
    var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1.5
        button.layer.borderColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        button.setTitle("Қосу", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .light)
        button.tintColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        button.addTarget(self, action: #selector(addNewZikrPressed), for: .touchUpInside)
        return button
    }()
    
    var textFieldStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closePressed))
        tapGesture.delegate = self
        transparentView.addGestureRecognizer(tapGesture)
        addNewZikrView.removeGestureRecognizer(tapGesture)
        view.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        
        zikirArray = realm.objects(Zikir.self)
        
        setUpNavBar()
        setUpTableView()
        setUpAddView()
    }
    
    @objc func donePressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addPressed() {
        close(isClosed: false)
    }
    
    @objc func addNewZikrPressed() {
        
        if let zikrName = zikrNameTF.text,
            let zikrMeaning = zikrMeaningTF.text,
            let zikrTranscript = zikrTranscriptTF.text,
            let zikrArabName = zikrArabTF.text {
            
            if zikrNameTF.text == "" || zikrMeaningTF.text == "" {
                zikrNameTF.addLine(position: .LINE_POSITION_BOTTOM, color: .red, width: 1.5)
                zikrMeaningTF.addLine(position: .LINE_POSITION_BOTTOM, color: .red, width: 1.5)
                errorLabel.isHidden = false
            } else {
                let newZikr = Zikir(value: [zikrName, zikrArabName, zikrMeaning, zikrTranscript, 0, 0])
                try! realm.write {
                    realm.add(newZikr)
                }
                tableView.reloadData()
                close(isClosed: true)
                emptyTF()
            }
        }
    }
    
    @objc func closePressed() {
        close(isClosed: true)
        emptyTF()
    }
    
    func close(isClosed: Bool) {
        self.transparentView.isHidden = isClosed
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.addNewZikrView.isHidden = isClosed
        })
    }
    
    func emptyTF() {
        zikrTranscriptTF.text = ""
        zikrMeaningTF.text = ""
        zikrArabTF.text = ""
        zikrNameTF.text = ""
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool  {
        if touch.view?.isDescendant(of: addNewZikrView) == true {
            return false
        }
        return true
    }
    
    func setUpNavBar() {
        view.addSubview(navBar)
        navBar.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(view.frame.size.width)
            make.height.equalTo(40)
        }
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ZikirCell.self, forCellReuseIdentifier: "cellId")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(navBar.snp.bottom).offset(18)
            make.leading.equalTo(self.view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-8)
        }
    }
    
    func setUpAddView() {
        view.addSubview(transparentView)
        transparentView.snp.makeConstraints { (make) in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        transparentView.addSubview(addNewZikrView)
        addNewZikrView.snp.makeConstraints { (make) in
            make.leading.equalTo(view).offset(16)
            make.trailing.equalTo(view).offset(-16)
            make.height.equalTo(352)
            make.center.equalTo(view)
        }
        
        addNewZikrView.addSubview(addZikrLabel)
        addZikrLabel.snp.makeConstraints { (make) in
            make.top.equalTo(addNewZikrView).offset(16)
            make.centerX.equalTo(addNewZikrView)
        }
        
        addNewZikrView.addSubview(errorLabel)
        errorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(addZikrLabel.snp.bottom).offset(4)
            make.centerX.equalTo(addNewZikrView)
        }
        
        setUpTextFields()
        
        addNewZikrView.addSubview(addButton)
        addButton.snp.makeConstraints { (make) in
            make.top.equalTo(textFieldStackView.snp.bottom).offset(24)
            make.width.equalTo(120)
            make.height.equalTo(40)
            make.centerX.equalTo(addNewZikrView)
        }
    }
    
    func setUpTextFields() {
        
        zikrNameTF.delegate = self
        zikrArabTF.delegate = self
        zikrMeaningTF.delegate = self
        zikrTranscriptTF.delegate = self
        
        textFieldStackView = UIStackView(arrangedSubviews: [zikrNameTF, zikrArabTF, zikrMeaningTF, zikrTranscriptTF])
        textFieldStackView.distribution = .fillEqually
        textFieldStackView.spacing = 16
        textFieldStackView.axis = .vertical
        
        addNewZikrView.addSubview(textFieldStackView)
        textFieldStackView.snp.makeConstraints { (make) in
            make.top.equalTo(addZikrLabel.snp.bottom).offset(32)
            make.leading.equalTo(addNewZikrView).offset(24)
            make.trailing.equalTo(addNewZikrView).offset(-24)
            make.height.equalTo(190)
        }
    }
}

extension ZikrListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if zikirArray.count != 0 {
            return zikirArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ZikirCell
        let zikirIndex = zikirArray[indexPath.row]
        cell.zikrTitle.text = zikirIndex.zikirName
        cell.zikrTranscript.text = zikirIndex.zikirTranscript
        cell.todayZikirLabel.text = "\(zikirIndex.todayCount)"
        cell.totalZikrLabel.text = "\(zikirIndex.totalCount)"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let zikirIndex = zikirArray[indexPath.row]
        let zikrToBeSend = Zikir(value: [zikirIndex.zikirName, zikirIndex.zikirArabName, zikirIndex.zikirMeaning,  zikirIndex.zikirTranscript, zikirIndex.todayCount, zikirIndex.totalCount])
        self.delegate?.sendDataToFirstViewController(zikrFromList: zikrToBeSend, zikirIndexPath: indexPath.row)
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let editingRow = zikirArray[indexPath.row]
        if editingStyle == .delete {
            try! self.realm.write {
                self.realm.delete(editingRow)
                tableView.reloadData()
            }
        }
    }
}

extension ZikrListViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1), width: 1.5)
        errorLabel.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 0.6274509804, green: 0.6745098039, blue: 0.7411764706, alpha: 1), width: 1.5)
    }
}

