//
//  HomeView.swift
//  ChatApp
//
//  Created by Luthfi Abdul Azis on 14/03/21.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    @State var tabSelection = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                TabView(selection: $tabSelection,
                        content:  {
                            ContactView(viewModel: viewModel).tabItem { Items(selected: 0) }.tag(0)
                            ChatView(viewModel: viewModel).tabItem { Items(selected: 1) }.tag(1)
                            SettingView().tabItem { Items(selected: 2) }.tag(2)
                        })
            }
            
            .navigationTitle(title[tabSelection])
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct Contact: View {
    var body: some View {
        Text("Contact")
    }
}

let icon = ["person.crop.circle.fill", "message.fill", "gear"]
let title = ["Contact", "Messages", "Setting"]

struct Items: View {
    
    @State var selected: Int
    
    var body: some View {
        VStack {
            Image(systemName: icon[selected])
            Text(title[selected])
        }
    }
}
