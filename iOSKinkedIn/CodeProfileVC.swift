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
    
    private var basicInfo: UILabel
    private var kinksMatched: UILabel
    private var vouchedBy: UILabel
    private var identies: TagListView
    
    var profile: Profile
    
    var matchedIds: [String] = ["pangender", "voyeur", "hedonist"]
    
    var topAnchor: NSLayoutConstraint?
    var initPanPos: CGPoint = CGPoint(x: 0.0, y: 0.0)
    
    init(_ profile: Profile) {
        self.profile = profile
        
        profileImage = UIImageView()
        angleView = AngleView()
        content = UIStackView()
        basicInfo = UILabel()
        kinksMatched = UILabel()
        vouchedBy = UILabel()
        identies = TagListView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // temp data
        profile.city = "New York, NY"
        profile.vouches = 20
        
        view.backgroundColor = UIColor.white
        
        angleView.isDirectionalLockEnabled = true
        
        self.setConstraints()
        self.setData()
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
        topAnchor = angleView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: CodeProfileVC.imageHeight - AngleView.deltaY)
        topAnchor?.isActive = true
        angleView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        angleView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        angleView.backgroundColor = UIColor.clear
        angleView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true

        angleView.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.topAnchor.constraint(equalTo: angleView.topAnchor, constant: 24).isActive = true
        content.bottomAnchor.constraint(equalTo: angleView.bottomAnchor).isActive = true
        content.leadingAnchor.constraint(equalTo: angleView.leadingAnchor, constant: 8).isActive = true
        content.trailingAnchor.constraint(equalTo: angleView.trailingAnchor, constant: -8).isActive = true
        content.widthAnchor.constraint(equalTo: angleView.widthAnchor).isActive = true
        
        content.alignment = .top
        content.axis = .vertical
        content.spacing = 16
        content.backgroundColor = UIColor.white
        
        angleView.isUserInteractionEnabled = true
        let panner = UIPanGestureRecognizer.init(target: self, action: #selector(onPan))
        panner.minimumNumberOfTouches = 1
        panner.maximumNumberOfTouches = 1
        angleView.addGestureRecognizer(panner)
        
        content.addArrangedSubview(basicInfo)
        
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
        
        content.addArrangedSubview(identies)
 
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
        
        if let _prompts = profile.prompts {
            for prompt in _prompts {
                if let _answer = prompt.answer, prompt.show {
                    let promptLabel = promptView(question: prompt.title, answer: _answer)
                    content.addArrangedSubview(promptLabel)
                }
            }
            content.addArrangedSubview(promptView(question: "I wanna", answer: "Go to sleep. Blah Rsh hfdjh jaska gfskdhk asfhfalhgafs!! Ajdfska hsadfi sdhha"))
            content.addArrangedSubview(promptView(question: "I like", answer: "Go to sleep. Blah Rsh hfdjh jaska gfskdhk asfhfalhgafs!! Ajdfska hsadfi sdhha"))
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
            /*
            if let _oldAnchor = self.topAnchor {
                angleView.removeConstraint(_oldAnchor)
            }
            
            self.topAnchor = angleView.topAnchor.constraint(
                equalTo: self.view.topAnchor,
                constant: CodeProfileVC.imageHeight - AngleView.deltaY - translation.y
            )
            self.topAnchor?.isActive = true
            */
            let minY = _view.bounds.height / 2
            
            var newY = self.initPanPos.y + translation.y
            newY = newY < minY ? minY : newY
            _view.center = CGPoint(x: self.initPanPos.x, y: newY)
        } else {
            _view.center = self.initPanPos
        }
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
