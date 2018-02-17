//
//  ThumbnailMatchCell.swift
//  iOSKinkedIn
//
//  Created by alice on 3/8/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

private enum ThumbnailState {
    case EMPTY
    case FILLED
}

class ThumbnailMatchCell: UICollectionViewCell {
    
    private var state = ThumbnailState.EMPTY
    private var picture: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        picture = UIImageView()
        picture.contentMode = .center
        picture.isUserInteractionEnabled = false
        picture.isHidden = true
        picture.isOpaque = false
        contentView.addSubview(picture)
        contentView.backgroundColor = UIColor.clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var frame = picture.frame
        frame.size.height = self.frame.size.height
        frame.size.width = self.frame.size.width
        frame.origin.x = 0
        frame.origin.y = 0
        picture.frame = frame
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = 20
        clipsToBounds = true
        if(state == ThumbnailState.EMPTY){
            guard let context = UIGraphicsGetCurrentContext() else {return}
            let fillColor = UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 0.6)
            let strokeColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
            
            context.addEllipse(in: rect)
            fillColor.setFill()
            context.fillPath()
            
            strokeColor.setStroke()
            context.strokeEllipse(in: rect)
        }
    }

    func setImage(_ publicId: String){
        picture = UIImageView(frame: frame)
        contentView.addSubview(picture)
        let url = "https://res.cloudinary.com/i99/image/upload/c_thumb,g_face,h_40,w_40/\(publicId)"
        let imgURL = URL(string: url)
        do {
            let imgData = try Data(contentsOf: imgURL!)
            let img = UIImage(data: imgData)
            self.picture.image = img
            self.picture.isHidden = false
        } catch {
            // TODO: use put in place holder image
            print("error loading profile picture")
        }
        state = ThumbnailState.FILLED
    }

    
}
