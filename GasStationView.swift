//
//  GasStationView.swift
//  Untitled
//
//  Created by Poorish Charoenkul on 24/2/2567 BE.
//

import SwiftUI
import UIKit

struct GasView: View {
    var imageName : String
    var gasName : String
    var gasRoute : String
    
    var body: some View {
        VStack{
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
            HStack{
                VStack(alignment: .leading){
                    Text(gasName)
                        .font(.title).bold()
                        .foregroundColor(.primary)
                    Text(" \(gasRoute) km")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    HStack{
                        Spacer()
                        Image(systemName: "location.square.fill")
                            .font(.system(size: 25))
                    }
                }
                .padding([.bottom, .horizontal])
            }
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 100/255, green: 100/255, blue:
                                100/255,
                              opacity: 0.5), lineWidth: 1)
        )
        .padding([.top, .horizontal])
    }
}

struct GasStationView: View {
    @State private var storyActive = false
    var body: some View {
        ZStack {
            VStack{
                ScrollView(.horizontal){
                    HStack{
                        GasView(imageName: "gas1", gasName: "PTT Gas Station", gasRoute: "5")
                            .frame(width: 350)
                        GasView(imageName: "gas2", gasName: "Esso Gas Station", gasRoute: "11")
                            .frame(width: 350)
                        GasView(imageName: "gas3", gasName: "PT Gas Station", gasRoute: "14")
                            .frame(width: 350)
                        GasView(imageName: "gas4", gasName: "Shell Gas Station", gasRoute: "23")
                            .frame(width: 350)
                        GasView(imageName: "gas5", gasName: "Exxon Gas Station", gasRoute: "35")
                            .frame(width: 350)
                        
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    GasStationView()
}


