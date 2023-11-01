//
//  UIImage+Extension.swift
//  WorldPang
//
//  Created by 권민재 on 2023/11/01.
//
import UIKit


extension CIImage {
    
    func resize(size: CGSize) -> CIImage {
        let scale = min(size.width, size.height)/min(self.extent.size.width, self.extent.size.height)
        let resizedImage = self.transformed(by: CGAffineTransform(
            scaleX: scale, y: scale))
        
        //이미지가 정사각형 형태가 아닐경우 초과하는 부분을 잘라내기 위한 코드
        let width = resizedImage.extent.width
        let height = resizedImage.extent.height
        let xOffset = ((CGFloat(width) - size.width)/2.0)
        let yOffset = ((CGFloat(height) - size.height)/2.0)
        let rect = CGRect(x: xOffset, y: yOffset, width: size.width, height: size.height)
        return resizedImage.clamped(to: rect).cropped(to:
                                                        CGRect(x: 0, y: 0, width: size.width, height: size.height))
    }
}
