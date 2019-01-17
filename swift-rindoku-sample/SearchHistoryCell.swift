//
//  SearchHistoryCell.swift
//  swift-rindoku-sample
//
//  Created by SCI01557 on 2019/01/17.
//  Copyright © 2019年 hicka04. All rights reserved.
//

import UIKit

class SearchHistoryCell: UITableViewCell {

    @IBOutlet private weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(history: SearchHistory) {
        label?.text = history.keyword
    }
}
