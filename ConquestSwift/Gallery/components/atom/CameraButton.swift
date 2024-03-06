//
//  CameraButton.swift
//  ConquestSwift
//
//  Created by changju.kim on 3/5/24.
//

import SwiftUI

struct CameraButton: View {
    var onCameraPress: () -> Void = {}

    var body: some View {
        Button(action: onCameraPress) {
            HStack {
                Text("카메라")
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(maxWidth: .infinity)
    }
}

#if DEBUG
struct CameraButton_Preview: PreviewProvider {
    struct CameraButtonPreview: View {
        var body: some View {
            CameraButton()
        }
    }

    static var previews: some View {
        CameraButtonPreview()
    }
}
#endif
