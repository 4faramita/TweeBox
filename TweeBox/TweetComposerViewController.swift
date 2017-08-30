//
//  TweetComposerViewController.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/30.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import UIKit
import YYText
import Gallery
import Lightbox
import Photos

class TweetComposerViewController: UIViewController {
    
    @IBOutlet weak var contentTextView: YYTextView!
    @IBOutlet weak var mentionButton: UIButton!
    @IBOutlet weak var hashtagButton: UIButton!
    @IBOutlet weak var lengthCountLabel: UILabel!
    @IBOutlet weak var sensitivitySwitch: UISwitch!
    
    fileprivate var imageList: [Image]?
    fileprivate var video: Video?
    
    @IBAction func addMedia(_ sender: UIButton) {
        let gallery = GalleryController()
        gallery.delegate = self
        Gallery.Config.Camera.imageLimit = 4
//        Gallery.Config.VideoEditor.maximumDuration
        Gallery.Config.initialTab = Config.GalleryTab.imageTab
        present(gallery, animated: true, completion: nil)
    }
    
    
    public var textContent: String? {
        didSet {
            lengthCountLabel.text = "\(remainingCharacters)"
        }
    }
    
    private var remainingCharacters: Int {
        return 140 - (textContent?.characters.count ?? 0)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        lengthCountLabel.text = "140"
        
        contentTextView.delegate = self
        contentTextView.font = UIFont.preferredFont(forTextStyle: .body)
        contentTextView.placeholderText = "Anything you wanna say?"
        contentTextView.isScrollEnabled = false
    }
    
    
    @IBAction func postTweet(_ sender: UIBarButtonItem) {
        
        guard remainingCharacters >= 0 else {
            return
        }
        
        let inReplyToStatusID: String? = nil
        
        let tweetParams = TweetPostParams(
            text: contentTextView.text,
            inReplyToStatusID: inReplyToStatusID,
            possiblySensitive: sensitivitySwitch.isOn,
            mediaIDs: nil
        )

        
        if let imageList = imageList, !(imageList.isEmpty) {
            
            let thumbnails = imageList.map {
                getAssetImage(asset: $0.asset, fullSize: false)
            }

            var mediaIDs = [String]() {
                didSet {
                    print(">>> imageList id count >> \(imageList.count)")
                    print(">>> media id count >> \(mediaIDs.count)")
                    
                    if mediaIDs.count == imageList.count {
                        
//                        let ids = "[\(mediaIDs.joined(separator: ", "))]"
//                        print(">>> ids >> \(ids)")
                        if mediaIDs.count == 1{
                            tweetParams.mediaIDs = mediaIDs[0]
                        } else {
                            tweetParams.mediaIDs = mediaIDs.description
                        }
                        
                        proceedPosting()
                    }
                }
            }
            
            for image in imageList{
                
                upload(image: image) { (mediaID) in
                    
                    mediaIDs.append(mediaID)
                }
            }
        }
        
        func proceedPosting() {
            
            let poster = TweetPoster(tweetParams: tweetParams)
            
            poster.postData { [weak self] (tweet) in
                if let tweet = tweet {
                    print(">>> tweet >> \(tweet.text)")
                    
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
    @IBAction private func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}


extension TweetComposerViewController: YYTextViewDelegate {
    
    func textViewDidChange(_ textView: YYTextView) {
        textContent = textView.text
    }
}


extension TweetComposerViewController: GalleryControllerDelegate {
    
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        let lightBoxImages = images.map { LightboxImage(image: ($0.uiImage(ofSize: PHImageManagerMaximumSize))!, text: "") }
        let lightboxController = LightboxController(images: lightBoxImages)
        lightboxController.dynamicBackground = true
        controller.present(lightboxController, animated: true, completion: nil)
    }

    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        imageList = images
        
        dismiss(animated: true, completion: nil)
    }

    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        
        self.video = video
        
        dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func upload(image: Image, handler: @escaping (String) -> Void) {
        
        print(">>> uploading >> \(image)")
        
        let imageData = getAssetData(asset: image.asset)
        
        let dataPoster = RESTfulClientWithMedia(imageData: imageData)
        dataPoster.getData({ (mediaID) in
            if let mediaID = mediaID {
                print(">>> media id >> \(mediaID)")
                handler(mediaID)
            }
        })
    }
    
    
    func getAssetImage(asset: PHAsset, fullSize: Bool) -> UIImage {
        
        let targetSize: CGSize
        if fullSize {
            targetSize = PHImageManagerMaximumSize
        } else {
            targetSize = CGSize(width: 150, height: 150)
        }
        
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var image = UIImage()
        option.isSynchronous = true
        
//        options.synchronous = false
//        options.deliveryMode = .HighQualityFormat
//        options.networkAccessAllowed = true
        
        manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: option, resultHandler: { (result, info) -> Void in
            image = result!
        })
        return image
    }
    
    func getAssetData(asset: PHAsset) -> Data {
        
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var imageData = Data()
        option.isSynchronous = true
        
        //        options.synchronous = false
        //        options.deliveryMode = .HighQualityFormat
        //        options.networkAccessAllowed = true
        
        manager.requestImageData(for: asset, options: option) { (data, string, orientation, hashables) in
            imageData = data!
        }
        return imageData
    }



}

extension TweetComposerViewController: LightboxControllerPageDelegate {
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        print(page)
    }
}

extension TweetComposerViewController: LightboxControllerDismissalDelegate {
    
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        // ...
    }
}
