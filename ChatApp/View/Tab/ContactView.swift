//
//  ContactView.swift
//  ChatApp
//
//  Created by Luthfi Abdul Azis on 14/03/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContactView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    @State var selectionItem: String? = nil
    
    var body: some View {
        List(viewModel.contactList, id: \.id) { contact in
            NavigationLink(destination: DetailView(receiver: contact), tag: contact.id, selection: $selectionItem){
                ItemContact(user: contact)
                    .onTapGesture {
                        self.selectionItem = contact.id
                    }
            }
        }
    }
}

struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct ItemContact: View {
    
    @State var user: User
    
    var body: some View {
        HStack {
            
            if user.photo.isEmpty {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.gray)
            } else {
                WebImage(url: URL(string: user.photo))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40, alignment: .center)
            }
            
            
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.headline)
                
                Text(user.email)
                    .font(.callout)
                    .foregroundColor(.gray)
            }
        }
    }
}
