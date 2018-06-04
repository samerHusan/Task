//
//  ImageCollection.swift
//  Demo
//
//  Created by developer-30 on 01/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import IDMPhotoBrowser

class ImageViewerController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    

    var itemsImage = [Image]()
    
    @IBOutlet var collectionImage: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       methodToFetchImages()
        
        let cellSize = CGSize(width:170 , height:170)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 11, left: 11.5, bottom: 11, right:11.5)
        layout.minimumLineSpacing = 11
        layout.minimumInteritemSpacing = 11
        collectionImage.setCollectionViewLayout(layout, animated: true)
        
        collectionImage.reloadData()
        // Do any additional setup after loading the view.
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc func showFullImage(sender: UIButton){
//        let imageCell = gesture.view
        var photos = [IDMPhoto]()
        
        for item in itemsImage {
            let imgUrl  = URL(string: item.imgUrl!)
            let idmPhotoItem = IDMPhoto(url: imgUrl)
            photos.append(idmPhotoItem!)
        }
        
        let browser = IDMPhotoBrowser(photos: photos)
        browser?.delegate = self
        browser?.displayCounterLabel = false
        browser?.useWhiteBackgroundColor = false
        browser?.displayActionButton = false
        browser?.leftArrowImage =  UIImage(named: "IDMPhotoBrowser_customArrowLeft.png")
        browser?.rightArrowImage =  UIImage(named: "IDMPhotoBrowser_customArrowRight.png")
        browser?.doneButtonImage =  UIImage(named: "IDMPhotoBrowser_customDoneButton.png")
        browser?.leftArrowSelectedImage =  UIImage(named: "DMPhotoBrowser_customArrowLeftSelected.png")
        browser?.rightArrowSelectedImage =  UIImage(named: "IDMPhotoBrowser_customArrowRightSelected.png")
        browser?.view.tintColor = .white
        browser?.progressTintColor = .white
        browser?.trackTintColor = UIColor(white: 0.8, alpha: 1.0)
        browser?.setInitialPageIndex(UInt(sender.tag))
        
        self.present(browser!, animated: true, completion: nil)
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func methodToFetchImages()  {

        if Reachability.isConnectedToNetwork() {
            Loader.shared.showProgressView(view: self.view)
            NetworkManager.shared.getMethodToFetchData( { (json) in
                print(json)

                if json["status"].stringValue == "success" {
                   if let allPosts = json["data"].arrayObject as? [[String:Any]] {
                    
                        let itemsImage  = allPosts.map({ (info) -> Image in
                           Image.init(withJson: info)
                       })
                      self.itemsImage = itemsImage
                       self.collectionImage.reloadData()
                  }
                }else{
                    let error = json["info"]["error"].stringValue
                    Utility.showMessageDialog(onController: self, withTitle: "Alert", withMessage:error)
                }

            }) { (error) in
                print(error)
                stopLoader()
            }
        }else{
            Utility.showMessageDialog(onController: self, withTitle: "Alert", withMessage: "Network is not available")
        }
    }
    
    //MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsImage.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! ImageCell
        cell.button.tag = indexPath.row
               // cell.button.tag = indexPath.row
        cell.button.addTarget(self, action: #selector(self.showFullImage(sender:)), for: .touchUpInside)
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        
        let thumbUrlString = itemsImage[indexPath.row].thumbUrl
        let thumbUrl:URL = URL(string: thumbUrlString!)!
        
        // Start background thread so that image loading does not make app unresponsive
        DispatchQueue.global(qos: .userInitiated).async {
            let imageData:NSData = NSData(contentsOf: thumbUrl)!
            // When from background thread, UI needs to be updated on main_queue
            DispatchQueue.main.async {
                let image = UIImage(data: imageData as Data)
                cell.imageView.image = image
            }
        }
        return cell
    }
    
    @objc func panGesture(sender: UIPanGestureRecognizer){
//        let point = sender.location(in: view)
//        let panGestuc re = sender.view
//        panGesture?.center = point
//        print(point)
        self.navigationController?.popViewController(animated: true)
    }

}


extension ImageViewerController: IDMPhotoBrowserDelegate {
    func photoBrowser(_ photoBrowser: IDMPhotoBrowser!, didShowPhotoAt index: UInt) {
        
    }
    
}
