//
//  Assets.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/27/25.
//
import SwiftUI

enum ImageAsset: String {
    case mercedes, bmw, audi, porshe, tesla, lexus
    case speedometr, speed, odometr
}

enum CFont {
    static func bold(_ size: CGFloat) -> Font {
        return Font.custom("ALSPofo-Bold", size: size)
    }
    static func regular(_ size: CGFloat) -> Font {
        return Font.custom("ALSPofo-Regular", size: size)
    }
    static func light(_ size: CGFloat) -> Font {
        return Font.custom("ALSPofo-Light", size: size)
    }
}
