//
//  Extension+Image.swift.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/27/25.
//
import SwiftUI

extension Image {
    init(_ asset: ImageAsset) {
        self.init(asset.rawValue)
    }
}
