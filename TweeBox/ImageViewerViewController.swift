//
//  ImageViewerViewController.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/11.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import UIKit
import Photos
import Kingfisher
import JDStatusBarNotification

class ImageViewerViewController: PannableViewController {
        
    public var imageURL: URL!
    
    public var imageView = UIImageView()
    
    public var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            
            centerIt()
            
            /*
             the line above is because
             when the image is set by Kingfisher,
             it seems hard to dismiss the image viewer by swipe
             unless zoom it first.
             So this is a simple yet valid workaround
             */
            
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressToCallShareSheet(_:)))
            scrollView?.addGestureRecognizer(longPress)
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.maximumZoomScale = 5.0
            scrollView.minimumZoomScale = 0.5
            scrollView.contentSize = imageView.frame.size
            scrollView.addSubview(imageView)
        }
    }
    
    var photoIndex: Int!
    
    
    @IBAction func tapToDismiss(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doubleTapToZoom(_ sender: UITapGestureRecognizer) {
        
        if scrollView.zoomScale > 1.0 {
            scrollView.setZoomScale(1.0, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }

    
    private func addTapGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToDismiss(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapToZoom(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.numberOfTouchesRequired = 1
        view.addGestureRecognizer(doubleTapGesture)
        
        tapGesture.require(toFail: doubleTapGesture)
    }
    
    
    // MARK - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTapGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if image == nil, imageURL != nil {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: imageURL)
        }
    }
    
    
    @IBAction func longPressToCallShareSheet(_ sender: UITapGestureRecognizer) {
        
        func popShareSheet() {
            
            let image = self.image ?? UIImage()
            
            let activityViewController = UIActivityViewController(activityItems: [image, imageURL], applicationActivities: nil)
            
            if presentedViewController == nil {
                present(activityViewController, animated: true, completion: nil)
            } else {
                self.dismiss(animated: false) { [weak self] () -> Void in
                    self?.present(activityViewController, animated: true, completion: nil)
                }
            }
        }
        
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "Save To Camera Roll", style: .default) { [weak self] (alertAction) in
            self?.saveToCameraRoll()
        })
        alert.addAction(UIAlertAction(title: "Copy Link", style: .default) { [weak self] (alertAction) in
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                UIPasteboard.general.string = self?.imageURL.absoluteString
            
//                var successMessage = Murmur(title: "Image Link Copied to Clipboard.")
//                successMessage.backgroundColor = .green
//                successMessage.titleColor = .black
                
                DispatchQueue.main.async {
//                    Whisper.show(whistle: successMessage, action: .show(1.5))
                    JDStatusBarNotification.show(withStatus: "Image Link Copied to Clipboard.", dismissAfter: 1.5)
                }
            }

        })
        alert.addAction(UIAlertAction(title: "More…", style: .default) { (alertAction) in
            popShareSheet()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in })
        
        if (sender.state == .began) {
            if presentedViewController == nil {
                present(alert, animated: true, completion: nil)
            } else {
                self.dismiss(animated: false) { [weak self] () -> Void in
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    
//    private func blur() {
//        // not using it
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.addSubview(blurEffectView)
//    }
    
    fileprivate func centerIt() {
        if image != nil, imageView.frame.size.height > 0, imageView.frame.size.width > 0 {
            let imageFactor = imageView.frame.size.width / imageView.frame.size.height
            
            let screenWidth = UIScreen.main.bounds.size.width
            let screenHeight = UIScreen.main.bounds.size.height
            let screenFactor = screenWidth / screenHeight
            
            if imageFactor >= screenFactor {  // image is wider
                imageView.frame.size.width = screenWidth
                imageView.frame.size.height = screenWidth / imageFactor
            } else {  // image is higher
                imageView.frame.size.height = screenHeight
                imageView.frame.size.width = screenHeight * imageFactor
            }
            imageView.center = view.center
            scrollView.setZoomScale(1.0, animated: true)
        }
    }
    
}

extension ImageViewerViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // center the image as it becomes smaller than the size of the screen
        let boundsSize = scrollView.bounds.size
        var frameToCenter = imageView.frame
        
        // center horizontally and vertically
        let widthDiff = boundsSize.width  - frameToCenter.size.width
        let heightDiff = boundsSize.height - frameToCenter.size.height
        frameToCenter.origin.x = (widthDiff > 0) ? widthDiff / 2 : 0
        frameToCenter.origin.y = (heightDiff > 0) ? heightDiff / 2 : 0
        
        imageView.frame = frameToCenter

    }
    
    override func viewDidLayoutSubviews() {
        centerIt()
    }
}

extension ImageViewerViewController {
    func saveToCameraRoll() {
        if let image = image {
            
//            var savingMessage = Murmur(title: "Saving to Camera Roll…")
//            savingMessage.backgroundColor = .orange
//            savingMessage.titleColor = .white
//            
//            Whisper.show(whistle: savingMessage, action: .present)

            JDStatusBarNotification.show(withStatus: "Saving to Camera Roll…", styleName: "JDStatusBarStyleWarning")
            JDStatusBarNotification.showActivityIndicator(true, indicatorStyle: .gray)
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { (timer) in
                
                DispatchQueue.global(qos: .userInitiated).async {
                    
                    PHPhotoLibrary.shared().performChanges({
                        
                        PHAssetChangeRequest.creationRequestForAsset(from: image)
                        
                    }, completionHandler: { success, error in
                        
                        if success {
                                                        
//                            Whisper.hide()
//                            
//                            var successMessage = Murmur(title: "Saved To Camera Roll Successfully.")
//                            successMessage.backgroundColor = .green
//                            successMessage.titleColor = .black
                            
                            DispatchQueue.main.async {
//                                Whisper.show(whistle: successMessage, action: .show(1.5))
                                JDStatusBarNotification.show(withStatus: "Saved To Camera Roll Successfully.", dismissAfter: 1.5, styleName: "JDStatusBarStyleSuccess")
                                JDStatusBarNotification.showActivityIndicator(false, indicatorStyle: .gray)
                            }
                        } else if let error = error {
                            
//                            var errorMessage = Murmur(title: "Failed to Save: \(error.localizedDescription)")
//                            errorMessage.backgroundColor = .red
//                            errorMessage.titleColor = .black
                            
                            DispatchQueue.main.async {
//                                Whisper.show(whistle: errorMessage, action: .show(1.0))
                                JDStatusBarNotification.show(withStatus: "Failed to Save: \(error.localizedDescription)", dismissAfter: 1.5, styleName: "JDStatusBarStyleError")
                                JDStatusBarNotification.showActivityIndicator(false, indicatorStyle: .gray)
                            }
                        } else {
                            
//                            var errorMessage = Murmur(title: "Failed to Save.")
//                            errorMessage.backgroundColor = .red
//                            errorMessage.titleColor = .black
                            
                            DispatchQueue.main.async {
//                                Whisper.show(whistle: errorMessage, action: .show(1.0))
                                JDStatusBarNotification.show(withStatus: "Failed to Save", dismissAfter: 1.5, styleName: "JDStatusBarStyleError")
                                JDStatusBarNotification.showActivityIndicator(false, indicatorStyle: .gray)

                            }
                        }
                    })
                }
            })
        }
    }
}
