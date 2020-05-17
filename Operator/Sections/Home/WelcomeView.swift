//
//  WelcomeView.swift
//  Operator
//
//  Created by Brian Michel on 5/17/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Welcome to Operator").font(.largeTitle)
            Text("Operator is a small application that lets you backup and restore yourTeenage Engineering devices.\n\nIt also will let you load some drum samples/create drum kits on-the-go as needed.\n\nBest of luck, and have fun. ✌️")
            Spacer()
            Button(action: {
                UIApplication.shared.open(URL(string: "https://www.twitter.com/brianmichel")!)
            }, label: {
                Text("Contact the author")
            }).buttonStyle(AppleButtonStyle(backgroundColor: Colors.op1Blue.asColor()))
        }.padding()
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
