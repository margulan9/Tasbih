//
//  ZikrListViewController.swift
//  Tasbih
//
//  Created by Sugirbay Margulan on 4/16/20.
//  Copyright © 2020 Sugirbay Margulan. All rights reserved.
//

import UIKit
import SnapKit

class ZikrListViewController: UIViewController, UIGestureRecognizerDelegate {

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
        button.tintColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        button.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closePressed))
        tapGesture.delegate = self
        transparentView.addGestureRecognizer(tapGesture)
        addNewZikrView.removeGestureRecognizer(tapGesture)
        view.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        setUpNavBar()
        setUpTableView()
        setUpAddView()
    }
    
    @objc func donePressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addPressed() {
        self.transparentView.isHidden = false
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.addNewZikrView.isHidden = false
        })
    }
    
    @objc func closePressed() {
        self.transparentView.isHidden = true
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.addNewZikrView.isHidden = true
        })
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
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.5)
            make.center.equalTo(view)
        }
        
        addNewZikrView.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(addNewZikrView).offset(8)
            make.leading.equalTo(addNewZikrView).offset(8)
            make.height.width.equalTo(25)
        }
    }
}

extension ZikrListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ZikirCell
        return cell
    }
    
    
}
