//
//  Extension.swift
//  ConquestSwift
//
//  Created by changju.kim on 2/23/24.
//

import Foundation
import SwiftUI

extension View {
    func intersperse<V: View>(_ divider: V) -> some View {
        variadic { children in
            if let c = children.first {
                c
                ForEach(children.dropFirst(1)) { child in
                    divider
                    child
                }
            }
        }
    }
}
