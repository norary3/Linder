//
//  ChannelTableViewCell.swift
//  Lindar
//
//  Created by 박종훈 on 2017. 1. 25..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit

private let cellReuseIdentifier = "channelCell"
let channelTableViewCellPadding: CGFloat = 10.0

class ChannelTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    
//    var channelScope: ChannelScope = .all {
//        didSet {
//            EventDataController.shared.getChannels(scope: channelScope) { (channel) in
//                self.channels.append(channel)
//                self.collectionView.insertItems(at: [IndexPath(item: self.channels.count - 1, section: 0)])
//            }
//        }
//    }
    var allowsMultipleSelection = false {
        didSet {
            collectionView.allowsMultipleSelection = self.allowsMultipleSelection
        }
    }
    var containerVC: UIViewController?
    
    var channels: [Channel] = []
    
    private let userDC = UserDataController.shared

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib.init(nibName: "ChannelCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.allowsMultipleSelection = self.allowsMultipleSelection
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8.0, bottom: 0, right: 8.0)
    }
    
    func insertNewItem() {
        self.collectionView.insertItems(at: [IndexPath(item: channels.count - 1, section: 0)])
    }

    // MARK: - CollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channels.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ChannelCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! ChannelCollectionViewCell
        // Configure the cell
        cell.channel = channels[indexPath.item]
        return cell
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell: ChannelCollectionViewCell = collectionView.cellForItem(at: indexPath) as? ChannelCollectionViewCell {
            if self.allowsMultipleSelection {
                cell.setSelected()
                print(cell.channel.title, " Selected")
                userDC.user.channelIDs.append(cell.channel.id)
                print(")userDC.user.channelIDs", userDC.user.channelIDs)
            }
            else {
                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChannelDetailView") as? ChannelDetailViewController {
                    viewController.channel = cell.channel
                    if let navigator = self.containerVC?.navigationController {
                        navigator.pushViewController(viewController, animated: true)
                    }
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell: ChannelCollectionViewCell = collectionView.cellForItem(at: indexPath) as? ChannelCollectionViewCell {
            if self.allowsMultipleSelection {
                cell.setDeSelected()
                print(cell.title.text ?? "nothing", " deselected")
                let index = userDC.user.channelIDs.index(of: cell.channel.id)
                userDC.user.channelIDs.remove(at: index!)
            }
        }
    }
}
