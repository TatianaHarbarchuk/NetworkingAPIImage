//
//  ImageSaver.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 20.06.2023.
//

import UIKit

protocol ImageSaverDelegate: AnyObject {
    func isSuccessDownload()
    func isFailedDownload()
}

final class ImageLoader: NSObject {
    
    weak var delegate: ImageSaverDelegate?
    
    func download(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        switch error {
        case .none:
            delegate?.isSuccessDownload()
        case .some:
            delegate?.isFailedDownload()
        }
    }
}
