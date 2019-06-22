
//
//  UserTableViewCell.swift
//  Imessenger
//
//  Created by Ambar Kumar on 05/06/19.
//  Copyright © 2019 Ambar Kumar. All rights reserved.
//

import UIKit
protocol UserTableViewCellDelegate {
    func didTapAvatarImage(indexPath : IndexPath)
}
class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    var delegate : UserTableViewCellDelegate?
    
    var indexPath : IndexPath!
    var tagGesture = UITapGestureRecognizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tagGesture.addTarget(self, action: #selector(self.avatarTap))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tagGesture)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func generateCellWith(fuser : FUser, indexPath : IndexPath){
        self.indexPath = indexPath
        self.fullNameLabel.text = fuser.fullname
        
        if fuser.avatar != ""{
            imageFromData(pictureData: fuser.avatar) { (avatarImage) in
                if avatarImage != nil{
                    self.avatarImageView.image = avatarImage!.circleMasked
                }
            }
        }
        
    }
    
    @objc func avatarTap(){
        print("tap on avatar \(indexPath)")
        delegate!.didTapAvatarImage(indexPath: indexPath)
    }
}
