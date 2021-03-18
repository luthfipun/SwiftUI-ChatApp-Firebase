//
//  DetailView.swift
//  ChatApp
//
//  Created by Luthfi Abdul Azis on 15/03/21.
//

import SwiftUI
import Firebase

struct DetailView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel = DetailViewModel()
    
    @State var receiver: User
    @State var message: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            
            ScrollViewReader { sr in
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(viewModel.messages, id: \.id) { message in
                        ItemData(message: message, userId: viewModel.currentUser!.uid)
                            .rotationEffect(.radians(.pi))
                            .scaleEffect(x: -1, y: 1, anchor: .center)
                    }
                }
                .rotationEffect(.radians(.pi))
                .scaleEffect(x: -1, y: 1, anchor: .center)
            }
            
            Spacer(minLength: 0)
            
            Divider().padding(0)
            HStack(spacing: 10) {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .padding(1)
                })
                
                TextField("type message..", text: $message)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    
                    if message.isEmpty {
                       return
                    }
                    
                    viewModel.sendData(to: receiver.id, text: message)
                    message = ""
                    
                }, label: {
                    Circle()
                        .frame(width: 32, height: 32, alignment: .center)
                        .overlay(
                            Image(systemName: "paperplane.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                                .rotationEffect(.init(degrees: 45.0))
                        )
                })
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color.gray.opacity(0.1))
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle(Text(receiver.name), displayMode: .inline)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
                
                Text("Back")
                    .foregroundColor(.blue)
            }
        }))
        .onAppear {
            viewModel.syncData(to: receiver.id)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    
    static var receiver = User(id: UUID().uuidString, name: "", email: "", photo: "", timestamp: Timestamp(date: Date()))
    
    static var previews: some View {
        DetailView(receiver: receiver)
    }
}

struct ItemData: View {
    
    @State var message: Message
    @State var userId: String
    
    var body: some View {
        VStack(alignment: message.sender == userId ? .trailing : .leading, spacing: 0) {
            
            Text("\(timeAgo(timestamp: message.timestamp!))")
                .font(.footnote)
                .foregroundColor(Color.gray.opacity(0.5))
                .padding(.horizontal, 5)
            
            VStack {
                Text(message.text)
                    .font(.callout)
                    .foregroundColor(message.sender == userId ? .white : .black)
            }
            .padding()
            .background(message.sender == userId ? .blue : Color.gray.opacity(0.4))
            .cornerRadius(message.sender == userId ? 20 : 0, corners: .topLeft)
            .cornerRadius(message.sender == userId ? 0 : 20, corners: .topRight)
            .cornerRadius(20, corners: .bottomLeft)
            .cornerRadius(20, corners: .bottomRight)
            .padding(.horizontal, 5)
            .padding(.bottom, 5)
            
        }.frame(maxWidth: .infinity, alignment: message.sender == userId ? .trailing : .leading)
    }
}
