//
//  ChatView.swift
//  ChatApp
//
//  Created by Luthfi Abdul Azis on 17/03/21.
//

import SwiftUI

struct ChatView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    @State var selectionItem: String? = nil
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.recents.indices) { index in
                NavigationLink(destination: DetailView(receiver: viewModel.recents[index].user), tag: viewModel.recents[index].id, selection: $selectionItem){
                    ItemRecent(recent: $viewModel.recents[index])
                        .onTapGesture {
                            self.selectionItem = viewModel.recents[index].id
                        }
                }
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct ItemRecent: View {
    
    @Binding var recent: Recent
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 52))
                .foregroundColor(.gray)
                .padding(.leading, 8)
            
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(recent.user.name)
                            .font(.callout)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                        
                        Text(recent.text)
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .lineLimit(2)
                            .lineSpacing(0)
                        
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .trailing) {
                        Text(timeAgo(timestamp: recent.timestamp!))
                            .font(.footnote)
                            .foregroundColor(.blue)
                        
                        Text("12")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(4)
                            .background(
                                Circle().fill(Color.blue)
                            ).hidden()
                    }.padding(.trailing, 8)
                }
                Divider()
            }
        }
    }
}
