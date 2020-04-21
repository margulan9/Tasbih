//
//  CounterViewController.swift
//  Tasbih
//
//  Created by Sugirbay Margulan on 4/15/20.
//  Copyright © 2020 Sugirbay Margulan. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift

class CounterViewController: UIViewController, UIGestureRecognizerDelegate, MyDataSendingDelegateProtocol {
    func sendDataToFirstViewController(zikrFromList: Zikir, zikirIndexPath: Int) {
        arabLabel.text = zikrFromList.zikirArabName
        if zikrFromList.zikirTranscript == "" {
            kazakhLabel.text = zikrFromList.zikirName
        } else {
            kazakhLabel.text = zikrFromList.zikirTranscript
        }
        meaningLabel.text = zikrFromList.zikirMeaning
        counterButton.setTitle("\(zikrFromList.todayCount)", for: .normal)
        indexPath = zikirIndexPath
        count = zikirArray[indexPath].todayCount
    }
    
    let realm = try! Realm()
    var zikirArray:Results<Zikir>!
    var count = 0
    var feedbackGenerator: UIImpactFeedbackGenerator?
    var zikr: Zikir?
    var indexPath:Int = 0
    
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
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
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
    
    var buttonStackView = UIStackView()
    
    var settingsView:UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = #colorLiteral(red: 0.7529411765, green: 0.7960784314, blue: 0.8509803922, alpha: 1)
        view.layer.masksToBounds = true
        return view
    }()
    
    var languageLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "Тіл:"
        return label
    }()
    
    var kazakhButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
        button.isEnabled = false
        button.setTitle("Қазақша", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        button.setTitleColor(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1), for: .normal)
       // button.addTarget(self, action: #selector(addNewZikrPressed), for: .touchUpInside)
        return button
    }()
    
    var russianButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        button.setTitle("Русский", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        button.tintColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
       // button.addTarget(self, action: #selector(addNewZikrPressed), for: .touchUpInside)
        return button
    }()
    
    var settingButtonStackView = UIStackView()
    
    var lineView:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.6, green: 0.631372549, blue: 0.6862745098, alpha: 1)
        return view
    }()
    var lineView2:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.6, green: 0.631372549, blue: 0.6862745098, alpha: 1)
        return view
    }()
    
    var darkModeLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "Қара Режимі"
        return label
    }()
    
    var soundLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "Діріл"
        return label
    }()
    
    var darkModeSwitch = UISwitch()
    var soundSwitch = UISwitch()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        zikirArray = realm.objects(Zikir.self)
        checkForEmptyArray()
        
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
        setUpSettingsView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }
    
    func checkForEmptyArray() {
        if !zikirArray.isEmpty {
            arabLabel.text = zikirArray[0].zikirArabName
            kazakhLabel.text = zikirArray[0].zikirTranscript
            meaningLabel.text = zikirArray[0].zikirMeaning
            counterButton.setTitle("\(zikirArray[0].todayCount)", for: .normal)
            count = zikirArray[0].todayCount
        } else {
            let newZikr = Zikir(value: ["Салауат", "اللّهُـمَّ صَلِّ عَلـى مُحمَّـد، وَعَلـى آلِ مُحمَّد", "Аллаһым, Мұхаммедке және оның отбасына рақым ете гөр.", "Aллаухумә салли 'алә Мухаммадин уа 'алә әәли Мухаммад", 0, 0])
            try! realm.write {
                realm.add(newZikr)
            }
        }
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
        self.transparentView.isHidden = false
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.settingsView.isHidden = false
        })
    }
    
    @objc func listPressed() {
        feedbackGenerator?.impactOccurred()
        updateCounter()
        let zikrVC = ZikrListViewController()
        zikrVC.delegate = self
        self.show(zikrVC, sender: self)
    }
    
    func updateCounter() {
        try! realm.write {
            zikirArray[indexPath].todayCount = count
        }
    }
    
    @objc func closePressed() {
        
        feedbackGenerator?.impactOccurred()
        self.transparentView.isHidden = true
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.meaningView.isHidden = true
        })
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.settingsView.isHidden = true
        })
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool  {
        if touch.view?.isDescendant(of: meaningView) == true || touch.view?.isDescendant(of: settingsView) == true{
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
    
    func setUpSettingsView() {
        transparentView.addSubview(settingsView)
        settingsView.snp.makeConstraints { (make) in
            make.leading.equalTo(transparentView).offset(32)
            make.trailing.equalTo(transparentView).offset(-32)
            make.bottom.equalTo(buttonStackView.snp.top).offset(-4)
            make.height.equalTo(154)
        }
        
        settingsView.addSubview(languageLabel)
        languageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(settingsView).offset(20)
            make.leading.equalTo(settingsView).offset(16)
        }
        
        buttonStackView = UIStackView(arrangedSubviews: [kazakhButton, russianButton])
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 10
        buttonStackView.axis = .horizontal
        
        settingsView.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { (make) in
            make.top.equalTo(settingsView).offset(14)
            make.trailing.equalTo(settingsView).offset(-8)
            make.height.equalTo(30)
            make.width.equalTo(160)
        }
        
        settingsView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(buttonStackView.snp.bottom).offset(8)
            make.leading.equalTo(settingsView).offset(16)
            make.trailing.equalTo(settingsView).offset(-8)
            make.height.equalTo(0.3)
        }
        
        settingsView.addSubview(darkModeLabel)
        darkModeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom).offset(16)
            make.leading.equalTo(settingsView).offset(16)
        }
        
        settingsView.addSubview(darkModeSwitch)
        darkModeSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        darkModeSwitch.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.trailing.equalTo(settingsView).offset(-8)
        }
        
        settingsView.addSubview(lineView2)
        lineView2.snp.makeConstraints { (make) in
            make.top.equalTo(darkModeSwitch.snp.bottom).offset(8)
            make.leading.equalTo(settingsView).offset(16)
            make.trailing.equalTo(settingsView).offset(-8)
            make.height.equalTo(0.3)
        }
        
        settingsView.addSubview(soundLabel)
        soundLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lineView2.snp.bottom).offset(16)
            make.leading.equalTo(settingsView).offset(16)
        }
        
        settingsView.addSubview(soundSwitch)
        soundSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        soundSwitch.snp.makeConstraints { (make) in
            make.top.equalTo(lineView2.snp.bottom).offset(10)
            make.trailing.equalTo(settingsView).offset(-8)
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
