//
//  SentMemeCollectionViewController.swift
//  Meme
//
//  Created by Manpreet Singh on 16/12/18.
//  Copyright © 2018 Manpreet Singh. All rights reserved.
//

import Foundation
import UIKit

class SentMemeCollectionViewController: UICollectionViewController{
    
    @IBOutlet var sentCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotationChanged), name: .UIDeviceOrientationDidChange, object: nil)
        sentCollectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .UIDeviceOrientationDidChange, object: nil)
    }
    
    fileprivate func setFlowLayout() {
        let space:CGFloat = 3.0
        var dimension = (view.frame.size.width - (2 * space)) / 3.0
        if UIApplication.shared.statusBarOrientation.isLandscape{
            dimension = (view.frame.size.height - (2 * space)) / 3.0
        }
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFlowLayout()
    }
    
    @objc func deviceRotationChanged() {
        setFlowLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemeCollectionViewCell", for: indexPath) as! SentMemeCollectionViewCell
        cell.bgImageView.image=memes[(indexPath as NSIndexPath).row].memedImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeDetailViewController = storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailViewController.meme = memes[(indexPath as NSIndexPath).row]
        navigationController!.pushViewController(memeDetailViewController, animated: true)
    }
   
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
}
