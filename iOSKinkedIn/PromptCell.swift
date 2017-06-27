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
    @IBOutlet var show: UISwitch!
    @IBOutlet var answer: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        answer.delegate = self
    }
    
    func setContent(_ prompt: BioPrompt){
        title.text = prompt.title
        show.isOn = prompt.show
        answer.text = prompt.answer ?? ""
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(!textView.text.isEmpty){
            self.show.isOn = true
        }
    }
    
    

}
