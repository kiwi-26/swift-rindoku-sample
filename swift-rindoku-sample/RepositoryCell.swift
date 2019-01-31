//
//  RepositoryCell.swift
//  swift-rindoku-sample
//
//  Created by SCI01557 on 2018/10/04.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import UIKit
import GitHubClient

class RepositoryCell: UITableViewCell {

    private var repositoryId: Int?
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var bookmarkButton: UIButton!
    var delegate: RepositoryCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(repository: Repository) {
        repositoryId = repository.id
        label.text = repository.fullName
    }
    
    func setBookmarkButton(bookmarked: Bool) {
        if bookmarked {
            bookmarkButton.setImage(UIImage.init(named: "round_bookmark_black_24pt"), for: .normal)
        } else {
            bookmarkButton.setImage(UIImage.init(named: "round_bookmark_border_black_24pt"), for: .normal)
        }
    }
    
    @IBAction func bookmarkButtonTapped (sender:AnyObject) {
        if let repositoryId = repositoryId {
            delegate?.bookmarkButtonDidTap(repositoryId: repositoryId)
        }
    }
}
