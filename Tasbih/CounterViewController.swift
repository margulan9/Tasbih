//
//  CounterViewController.swift
//  Tasbih
//
//  Created by Sugirbay Margulan on 4/15/20.
//  Copyright © 2020 Sugirbay Margulan. All rights reserved.
//

import UIKit
import SnapKit

class CounterViewController: UIViewController, UIGestureRecognizerDelegate, MyDataSendingDelegateProtocol {
    func sendDataToFirstViewController(zikrFromList: Zikir) {
        arabLabel.text = zikrFromList.zikirArabName
        kazakhLabel.text = zikrFromList.zikirTranscript
        meaningLabel.text = zikrFromList.zikirMeaning
    }
    
    var count = 0
    var feedbackGenerator: UIImpactFeedbackGenerator?
    var zikr: Zikir?
    
    var wordsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = #colorLiteral(red: 0.7529411765, green: 0.7960784314, blue: 0.8509803922, alpha: 1)
        view.layer.masksToBounds = true
        return view
    }()
    
    var topView = UIView()
    var bottomView = UIView()
    
    var arabLabel: UILabel = {
       let label = UILabel()
        label.text = "اللّهُـمَّ صَلِّ عَلـى مُحمَّـد، وَعَلـى آلِ مُحمَّد"
        label.textColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 30, weight: .thin)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    var kazakhLabel: UILabel = {
       let label = UILabel()
        label.text = "Aллаухумә салли 'алә Мухаммадин уа 'алә әәли Мухаммад"
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    var meaningButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Мағынасы", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.addTarget(self, action: #selector(meaningPressed), for: .touchUpInside)
        return button
    }()
    
    var transparentView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = UIColor(white: 0.9, alpha: 0.6)
        return view
    }()
    
    var meaningView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = #colorLiteral(red: 0.7529411765, green: 0.7960784314, blue: 0.8509803922, alpha: 1)
        view.layer.masksToBounds = true
        return view
    }()
    
    var meaningLabel: UILabel = {
        let label = UILabel()
        label.text = "Аллаһым, Мұхаммедке және оның отбасына рақым ете гөр."
        label.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
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

    
    var counterView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = #colorLiteral(red: 0.7529411765, green: 0.7960784314, blue: 0.8509803922, alpha: 1)
        view.layer.masksToBounds = true
        return view
    }()
    
    var counterButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(#colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1), for: .normal)
        button.setTitle("0", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 90, weight: .thin)
        button.addTarget(self, action: #selector(counterPressed), for: .touchUpInside)
        return button
    }()
    
    var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "settings")
        let resizedImage = image?.resized(to: CGSize(width: 25, height: 25))
        button.setImage(resizedImage, for: .normal)
        button.tintColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        button.addTarget(self, action: #selector(settingsPressed), for: .touchUpInside)
        return button
    }()
    
    var resetButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "reset")
        let resizedImage = image?.resized(to: CGSize(width: 25, height: 25))
        button.setImage(resizedImage, for: .normal)
        button.tintColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        button.addTarget(self, action: #selector(resetPressed), for: .touchUpInside)
        return button
    }()
    
    var listButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "list")
        let resizedImage = image?.resized(to: CGSize(width: 25, height: 25))
        button.setImage(resizedImage, for: .normal)
        button.tintColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        button.addTarget(self, action: #selector(listPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        let tap = UITapGestureRecognizer(target: self, action: #selector(closePressed))
        tap.delegate = self
        transparentView.addGestureRecognizer(tap)
        
        feedbackGenerator = UIImpactFeedbackGenerator.init(style: .light)
        feedbackGenerator?.prepare()
        
        setUpWordsView()
        setUpCounterView()
        setUpButtons()
        setUpMeaningView()
    }
    
    @objc func counterPressed() {
        count+=1
        counterButton.setTitle("\(count)", for: .normal)
        feedbackGenerator?.impactOccurred()
    }
    
    @objc func resetPressed() {
        count = 0
        counterButton.setTitle("\(count)", for: .normal)
        feedbackGenerator?.impactOccurred()
    }
    
    @objc func meaningPressed() {
        feedbackGenerator?.impactOccurred()
        self.transparentView.isHidden = false
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.meaningView.isHidden = false
        })
    }
    
    @objc func settingsPressed() {
        feedbackGenerator?.impactOccurred()
    }
    
    @objc func listPressed() {
        feedbackGenerator?.impactOccurred()
        let zikrVC = ZikrListViewController()
        zikrVC.delegate = self
        self.show(zikrVC, sender: self)
    }
    
    @objc func closePressed() {
        
        feedbackGenerator?.impactOccurred()
        self.transparentView.isHidden = true
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.meaningView.isHidden = true
        })
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool  {
        if touch.view?.isDescendant(of: meaningView) == true {
            return false
        }
        return true
    }
    
    
    func setUpWordsView() {
        view.addSubview(wordsView)
        wordsView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-32)
            make.height.equalTo(view).multipliedBy(0.5)
        }
        
        wordsView.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(wordsView)
            make.leading.equalTo(wordsView)
            make.trailing.equalTo(wordsView)
            make.height.equalTo(wordsView).multipliedBy(0.5)
        }
        
        topView.addSubview(arabLabel)
        arabLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(topView).offset(24)
            make.trailing.equalTo(topView).offset(-24)
            make.bottom.equalTo(topView).offset(-8)
        }
        
        wordsView.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalTo(wordsView)
            make.leading.equalTo(wordsView)
            make.trailing.equalTo(wordsView)
            make.height.equalTo(wordsView).multipliedBy(0.5)
        }
        
        bottomView.addSubview(kazakhLabel)
        kazakhLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(bottomView).offset(24)
            make.trailing.equalTo(bottomView).offset(-24)
            make.top.equalTo(bottomView).offset(8)
        }
        
        bottomView.addSubview(meaningButton)
        meaningButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(bottomView).offset(-8)
            make.centerX.equalTo(bottomView)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
    }
    
    func setUpCounterView() {
        view.addSubview(counterView)
        counterView.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-32)
            make.height.equalTo(view).multipliedBy(0.3)
        }
        
        counterView.addSubview(counterButton)
        counterButton.snp.makeConstraints { (make) in
            make.leading.equalTo(counterView).offset(16)
            make.trailing.equalTo(counterView).offset(-16)
            make.top.equalTo(counterView).offset(16)
            make.bottom.equalTo(counterView).offset(-16)
        }
    }
    
    func setUpButtons() {
        var buttonStackView = UIStackView()
        buttonStackView = UIStackView(arrangedSubviews: [resetButton, settingsButton, listButton])
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 10
        
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { (make) in
            make.top.equalTo(wordsView.snp.bottom).offset(4)
            make.bottom.equalTo(counterView.snp.top).offset(-4)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
        }
    }
    
    func setUpMeaningView() {
        view.addSubview(transparentView)
        transparentView.snp.makeConstraints { (make) in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(view)
        }

        transparentView.addSubview(meaningView)
        meaningView.snp.makeConstraints { (make) in
            make.leading.equalTo(transparentView).offset(16)
            make.trailing.equalTo(transparentView).offset(-16)
            make.bottom.equalTo(transparentView).offset(-64)
            make.height.equalTo(transparentView).multipliedBy(0.4)
        }

        meaningView.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(meaningView).offset(8)
            make.leading.equalTo(meaningView).offset(8)
            make.height.width.equalTo(25)
        }

        meaningView.addSubview(meaningLabel)
        meaningLabel.snp.makeConstraints { (make) in
            make.center.equalTo(meaningView)
            make.leading.equalTo(meaningView).offset(16)
            make.trailing.equalTo(meaningView).offset(-16)
        }
    }
}
extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
