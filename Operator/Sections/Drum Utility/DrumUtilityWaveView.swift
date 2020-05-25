//
//  DrumUtilityWaveView.swift
//  Operator
//
//  Created by Brian Michel on 5/17/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI

struct DrumUtilityWaveView: View {
    private enum Constants {
        static let fixedSamplesToShow: CGFloat = 3
    }

    @ObservedObject var viewModel: DrumUtilityWaveViewModel

    var body: some View {
        GeometryReader { reader in
            VStack {
                HStack {
                    Toggle(isOn: self.$viewModel.showRelativeSlicing, label: {
                        Text("Show relative slicing".localized(comment: "Button label that enabled slicing of samples based on their relative size."))
                    })
                }.padding()
                ScrollView(.horizontal, showsIndicators: false) {
                    ZStack(alignment: .bottom) {
                        Rectangle().fill(Color.clear)
                        HStack(spacing: 3) {
                            Spacer().frame(width: 10)
                            ForEach(self.viewModel.markers, id: \.id) { marker in
                                MarkerView(marker: marker).frame(
                                    width: self.width(for: marker, width: reader.size.width)
                                )
                            }
                            Spacer().frame(width: 10)
                        }
                    }
                }
            }
        }
    }

    private func width(for marker: SampleMarker, width: CGFloat) -> CGFloat {
        if viewModel.showRelativeSlicing {
            let duration = marker.end - marker.start
            return (CGFloat(duration) * width) + (width / 4)
        }

        return width / Constants.fixedSamplesToShow
    }
}

struct MarkerView: View {
    let marker: SampleMarker

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 12).fill(Colors.op1Gray.asColor())
                RoundedRectangle(cornerRadius: 2).frame(width: 4, height: 30, alignment: .leading)
            }
            Spacer()
        }
    }
}

struct DrumUtilityWaveView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DrumUtilityWaveView(viewModel: DrumUtilityWaveViewModel())
        }
    }
}
