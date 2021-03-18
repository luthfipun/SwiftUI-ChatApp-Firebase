//
//  Utils.swift
//  ChatApp
//
//  Created by Luthfi Abdul Azis on 17/03/21.
//

import Foundation
import SwiftUI
import Combine
import Firebase

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

func timeAgo(timestamp: Timestamp) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(timestamp.seconds))
    let calendar = Calendar.current
    return "\(calendar.component(.hour, from: date)):\(calendar.component(.minute, from: date))"
}
