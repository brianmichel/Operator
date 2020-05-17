//
//  BulletedVStack.swift
//  Operator
//
//  Created by Brian Michel on 5/17/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI

struct BulletedVStack: View {
    let items: [String]
    var font: Font = Font.system(size: 30, weight: .regular, design: .default)

    var bulletColor: Color = .secondary
    var spacing: CGFloat = 10

    var body: some View {
        VStack(alignment: .leading, spacing: self.spacing) {
            ForEach(items, id: \.self) { item in
                HStack(alignment: .center, spacing: 20) {
                    CircleBullet(
                        text: "\(self.items.firstIndex(of: item)! + 1)",
                        backgroundColor: self.bulletColor,
                        foregroundColor: .white
                    ).frame(maxWidth: 23, maxHeight: 23)
                    Text(item).font(self.font)
                }
            }
        }
    }
}

struct BulletedVStack_Previews: PreviewProvider {
    static var previews: some View {
        BulletedVStack(items: [
            "This is just one thing that should be on the list",
            "Here's another thing that should be on the list, but it's even longer so we can see wrapping behavior",
            "finally here's a short thing :)",
        ])
    }
}
