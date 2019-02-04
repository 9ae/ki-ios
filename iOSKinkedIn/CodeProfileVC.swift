//
//  CodeProfileVC.swift
//  iOSKinkedIn
//
//  Created by alice on 9/15/18.
//  Copyright © 2018 KinkedIn. All rights reserved.
//

import UIKit
import TagListView

class CodeProfileVC: UIViewController {
    
    static let imageHeight: CGFloat = 360
    
    private var profileImage: UIImageView
    private var angleView: AngleView
    private var content: UIStackView
    
    var basicInfo: UILabel
    var kinksMatched: UILabel
    var vouchedBy: UILabel
    private var identies: TagListView
    var kinks: TagListView
    private var showPic: UIBarButtonItem
    
    var profile: Profile
    
    // TODO find matched Ids
    var matchedIds: [String] = []

    var initPanPos: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var panner : UIPanGestureRecognizer?
    
    init(_ profile: Profile) {
        self.profile = profile
        
        profileImage = UIImageView()
        angleView = AngleView()
        content = UIStackView()
        basicInfo = UILabel()
        kinksMatched = UILabel()
        vouchedBy = UILabel()
        identies = TagListView()
        kinks = TagListView()
        showPic = UIBarButtonItem()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // temp data
        profile.city = "New York, NY"
        
        view.backgroundColor = UIColor.white
        
        angleView.isDirectionalLockEnabled = true
        
        self.setConstraints()
        self.setData()
        
        showPic = UIBarButtonItem(
            image: #imageLiteral(resourceName: "scroll_top"),
            style: .plain,
            target: self,
            action: #selector(self.onShowPic)
        )
        showPic.isEnabled = false
        self.navigationItem.setRightBarButton(showPic, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setConstraints() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(profileImage)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: CodeProfileVC.imageHeight).isActive = true
        profileImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        view.addSubview(angleView)
        angleView.translatesAutoresizingMaskIntoConstraints = false
        angleView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: CodeProfileVC.imageHeight - AngleView.deltaY).isActive = true
        angleView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        angleView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        angleView.backgroundColor = UIColor.clear
        angleView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true

        angleView.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.topAnchor.constraint(equalTo: angleView.topAnchor, constant: 32).isActive = true
        content.bottomAnchor.constraint(equalTo: angleView.bottomAnchor).isActive = true
        content.leadingAnchor.constraint(equalTo: angleView.leadingAnchor, constant: 8).isActive = true
        content.trailingAnchor.constraint(equalTo: angleView.trailingAnchor, constant: -8).isActive = true
        content.widthAnchor.constraint(equalTo: angleView.widthAnchor).isActive = true
        
        content.alignment = .top
        content.axis = .vertical
        content.spacing = 16
        content.backgroundColor = UIColor.white
        
        angleView.isUserInteractionEnabled = true
        enablePan()

        content.addArrangedSubview(basicInfo)
        
        if (!profile.is_myself) {
            let countStack = UIStackView()
            countStack.alignment = .leading
            countStack.axis = .horizontal
            countStack.spacing = 8
            countStack.heightAnchor.constraint(equalToConstant: 50).isActive = true
            countStack.addArrangedSubview(kinksMatched)
            if profile.vouches > 0 {
                countStack.addArrangedSubview(vouchedBy)
            }
            content.addArrangedSubview(countStack)
        }
        
        content.addArrangedSubview(identies)
        
        let kinksLabel = UILabel()
        kinksLabel.text = "I am into..."
        content.addArrangedSubview(kinksLabel)
        content.addArrangedSubview(kinks)
 
    }
    
    private func setData() {
        if let pictureURL = profile.picture {
            let imgURL = URL(string: pictureURL)
            do {
                let imgData = try Data(contentsOf: imgURL!)
                profileImage.image = UIImage(data: imgData)
            } catch {
                // TODO: use put in place holder image
                print("ERR loading profile picture")
            }
        }
        
        basicInfo.numberOfLines = 2
        var basicText = "\(profile.name), \(profile.age)"
        if let city = profile.city {
            basicText += "\n\(city)"
        }
        basicInfo.text = basicText
        
        kinksMatched.numberOfLines = 2
        kinksMatched.text = "\(profile.kinksMatched) kinks\n matched"
        
        if profile.vouches > 0 {
            vouchedBy.numberOfLines = 2
            vouchedBy.text = "vouched by\n \(profile.vouches) members"
        }
        
        let ids = profile.genders + profile.roles
        for id in ids {
            let tagv = TagView(title: id)
            if matchedIds.contains(id) {
                tagv.isHighlighted = true
            }
            identies.addTagView(tagv)
        }
        identies.alignment = .left
        identies.leadingAnchor.constraint(equalTo: content.leadingAnchor).isActive = true
        identies.trailingAnchor.constraint(equalTo: content.trailingAnchor).isActive = true
        identies.textFont = .systemFont(ofSize: 12)
        identies.tagBackgroundColor = ThemeColors.primaryLight
        identies.textColor = UIColor.black
        identies.cornerRadius = 6
        identies.paddingX = 4
        identies.paddingY = 2
        identies.tagHighlightedBackgroundColor = ThemeColors.primaryDark
        
        for k in profile.kinks {
            kinks.addTag(k.label)
        }
        kinks.alignment = .left
        kinks.leadingAnchor.constraint(equalTo: content.leadingAnchor).isActive = true
        kinks.trailingAnchor.constraint(equalTo: content.trailingAnchor).isActive = true
        kinks.textFont = .systemFont(ofSize: 12)
        kinks.tagBackgroundColor = ThemeColors.primaryLight
        kinks.textColor = UIColor.black
        kinks.cornerRadius = 6
        kinks.paddingX = 4
        kinks.paddingY = 2
        kinks.tagHighlightedBackgroundColor = ThemeColors.primaryDark
        
        if let _prompts = profile.prompts {
            for prompt in _prompts {
                if let _answer = prompt.answer, prompt.show {
                    let promptLabel = promptView(question: prompt.title, answer: _answer)
                    content.addArrangedSubview(promptLabel)
                }
            }
        }
    }
    
    private func promptView(question: String, answer: String) -> UILabel {
        let promptLabel = UILabel()
        let q = NSAttributedString(
            string: question,
            attributes: [ NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)])
        let a = NSAttributedString(
            string: " \(answer)",
            attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14) ]
        )
        let b = NSMutableAttributedString()
        b.append(q)
        b.append(a)
        promptLabel.attributedText = b
        promptLabel.numberOfLines = 5
        return promptLabel
    }
    
    @objc func onPan(recoginzer: UIPanGestureRecognizer){
        guard let _view = recoginzer.view else {return}
        let translation  = recoginzer.translation(in: _view.superview)
        
        if recoginzer.state == .began {
            self.initPanPos = _view.center
        }
        
        if recoginzer.state != .cancelled {
            let minY = _view.bounds.height / 2
            
            var newY = self.initPanPos.y + translation.y
            newY = newY < minY ? minY : newY

            _view.center = CGPoint(x: self.initPanPos.x, y: newY)
            
            if (newY == minY && translation.y < 0){
                disablePan(minY)
            }
        } else {
            _view.center = self.initPanPos
        }
    }
    
    @objc func onShowPic(_ sender: Any){
        if (angleView.isScrollEnabled) {
            angleView.scrollToTop()
            enablePan()
        }
    }
    
    private func disablePan(_ topY : CGFloat){
        guard let _panner = self.panner else {return}
        
        angleView.removeGestureRecognizer(_panner)
        angleView.isScrollEnabled = true
        angleView.center =  CGPoint(x: self.initPanPos.x, y: topY)
        angleView.isAngled = false
        angleView.setNeedsDisplay()
        
        showPic.isEnabled = true
        
    }
    
    private func enablePan(){
        let _panner = self.panner ?? UIPanGestureRecognizer(target: self, action: #selector(onPan))

        if self.panner == nil {
            _panner.minimumNumberOfTouches = 1
            _panner.maximumNumberOfTouches = 1
            self.panner = _panner
        } else {
            angleView.center = self.initPanPos
            angleView.isAngled = true
            angleView.setNeedsDisplay()
        }
        
        angleView.addGestureRecognizer(_panner)
        angleView.isScrollEnabled = false
        
        showPic.isEnabled = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
