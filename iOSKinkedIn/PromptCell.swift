//
//  PromptCell.swift
//  iOSKinkedIn
//
//  Created by alice on 6/27/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class PromptCell: UITableViewCell, UITextViewDelegate {
    
    
    @IBOutlet var title: UILabel!
    @IBOutlet var isPrivate: UISwitch!
    @IBOutlet var answer: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        answer.delegate = self
        
        answer.layer.cornerRadius = 8.0
        answer.clipsToBounds = true
        answer.textContainerInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
    
    func setContent(_ prompt: BioPrompt){
        title.text = prompt.title
        isPrivate.isOn = !prompt.show
        answer.text = prompt.answer ?? ""
    }

}
