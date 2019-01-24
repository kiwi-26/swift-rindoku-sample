//
//  RepositoryCell.swift
//  swift-rindoku-sample
//
//  Created by SCI01557 on 2018/10/04.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {

    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var bookmarkButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(repositoryName: String) {
        label.text = repositoryName
    }
}
