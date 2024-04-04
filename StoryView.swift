//
//  StoryView.swift
//  Untitled
//
//  Created by Poorish Charoenkul on 25/2/2567 BE.
//

import SwiftUI

struct StoryView: View {
    @State private var storyActive = false
    var body: some View {
        TabView{
            OnboardView(imageName: "house.and.flag", titleName: "1. Sleep at gas station", description: "The best way to do when you feel sleepy is sleep because if you think that you can drive a little bit it may cause accident by you or other. So feel sleepy, go sleep!")
            OnboardView(imageName: "music.mic", titleName: "2. Sing a long!", description: "If you have a long drive try sing a long. Sing a song cause you feel less sleepy and also make you feel happier.")
            OnboardView(imageName: "phone.bubble.fill", titleName: "3. Call Someone", description: "If it's not bother the person you call, please make a phone call to make sure that you have consciousness and also keep yourself awake.")
            
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct OnboardView: View {
    let imageName: String
    let titleName: String
    let description: String
    var body: some View {
        VStack{
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 300,height: 300)
            
            Text(titleName)
                .font(.title).bold()
            
            Text(description)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal,40)
    }
}

#Preview {
    StoryView()
}

