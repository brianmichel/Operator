//
//  CircleBullet.swift
//  Operator
//
//  Created by Brian Michel on 5/17/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI

struct CircleBullet: View {
    var text: String

    var backgroundColor: Color = .secondary
    var foregroundColor: Color = .primary

    var body: some View {
        GeometryReader { reader in
            ZStack {
                Circle().foregroundColor(self.backgroundColor)
                Text(self.text)
                    .foregroundColor(self.foregroundColor)
                    .font(.system(size: reader.size.height > reader.size.width ? reader.size.width * 0.6 : reader.size.height * 0.6, weight: .bold, design: .rounded))
            }
        }
    }
}

struct CircleBullet_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircleBullet(text: "1").frame(maxWidth: 40, maxHeight: 40)
            CircleBullet(text: "2")
            CircleBullet(text: "3", backgroundColor: .red)
        }
    }
}
