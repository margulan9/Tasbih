//
//  ZikirCell.swift
//  Tasbih
//
//  Created by Sugirbay Margulan on 4/16/20.
//  Copyright © 2020 Sugirbay Margulan. All rights reserved.
//

import UIKit
import SnapKit

class ZikirCell: UITableViewCell {
    
    var zikrView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = #colorLiteral(red: 0.8823529412, green: 0.8980392157, blue: 0.9215686275, alpha: 1)
        view.layer.masksToBounds = true
        return view
    }()
    
    var zikrTitle: UILabel = {
        let label = UILabel()
        label.text = "Cалауат"
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.numberOfLines = 0
        return label
    }()
    
    var zikrSubtitle: UILabel = {
        let label = UILabel()
        label.text = "Aллаухумә салли 'алә Мухаммадин уа 'алә әәли Мухаммад"
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        label.numberOfLines = 0
        return label
    }()
    
    var amountLabel: UILabel = {
        let label = UILabel()
        label.text = "БҮГІН / БАРЛЫҒЫ"
        label.font = UIFont.systemFont(ofSize: 11, weight: .light)
        label.textColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        label.numberOfLines = 0
        return label
    }()
    
    var todayZikirLabel: UILabel = {
        let label = UILabel()
        label.text = "100"
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = #colorLiteral(red: 0.4, green: 0.4392156863, blue: 0.4901960784, alpha: 1)
        label.numberOfLines = 0
        return label
    }()
    
    var separatorLabel: UILabel = {
        let label = UILabel()
        label.text = "/"
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        return label
    }()
    
    var totalZikrLabel: UILabel = {
        let label = UILabel()
        label.text = "100"
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        label.numberOfLines = 0
        return label

    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        setUpLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpLayouts() {
        addSubview(zikrView)
        zikrView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(8)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self).offset(-8)
            make.height.greaterThanOrEqualTo(40)
        }
        
        zikrView.addSubview(zikrTitle)
        zikrTitle.snp.makeConstraints { (make) in
            make.leading.equalTo(zikrView).offset(16)
            make.top.equalTo(zikrView).offset(8)
            make.trailing.equalTo(zikrView).offset(-16)
        }
        
        zikrView.addSubview(zikrSubtitle)
        zikrSubtitle.snp.makeConstraints { (make) in
            make.leading.equalTo(zikrView).offset(16)
            make.top.equalTo(zikrTitle.snp.bottom).offset(4)
            make.trailing.equalTo(zikrView).offset(-16)
        }
        
        zikrView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(zikrView).offset(16)
            make.top.equalTo(zikrSubtitle.snp.bottom).offset(12)
            make.trailing.equalTo(zikrView).offset(-16)
        }
        
        zikrView.addSubview(todayZikirLabel)
        todayZikirLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(zikrView).offset(16)
            make.top.equalTo(amountLabel.snp.bottom).offset(4)
            make.bottom.equalTo(zikrView).offset(-8)
        }
        zikrView.addSubview(separatorLabel)
        separatorLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(todayZikirLabel.snp.trailing).offset(3)
            make.top.equalTo(amountLabel.snp.bottom).offset(4)
            make.bottom.equalTo(zikrView).offset(-8)
        }
        zikrView.addSubview(totalZikrLabel)
        totalZikrLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(separatorLabel.snp.trailing).offset(3)
            make.top.equalTo(amountLabel.snp.bottom).offset(4)
            make.bottom.equalTo(zikrView).offset(-8)
        }
    }
    
}
