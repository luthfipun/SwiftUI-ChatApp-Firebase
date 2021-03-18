//
//  DetailViewModel.swift
//  ChatApp
//
//  Created by Luthfi Abdul Azis on 17/03/21.
//

import Foundation
import Firebase

class DetailViewModel: ObservableObject {
    @Published var messages = [Message]()
    @Published var chatId: String = ""
    @Published var currentUser = Auth.auth().currentUser
    
    private var db = Firestore.firestore()
}

extension DetailViewModel {
    
    func syncData(to: String) {
        db.collection(StoragePath.CHAT.rawValue)
            .whereField("identifires", arrayContains: currentUser!.uid+to)
            .getDocuments { querySnapshot, error in
                
                guard let documents = querySnapshot?.documents else {
                    print("No chat")
                    return
                }
                
                if documents.count > 0 {
                    self.chatId = documents[0].documentID
                    self.fetchData(chatId: self.chatId)
                }else {
                    let chatId = self.createChatId(to: to)
                    self.chatId = chatId
                    self.fetchData(chatId: self.chatId)
                }
            }
    }
    
    func fetchData(chatId: String) {
        db.collection(StoragePath.CHAT.rawValue)
            .document(chatId)
            .collection(StoragePath.MESSAGE.rawValue)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("No Messages")
                    return
                }
                
                self.messages = documents.map { document in
                    let data = document.data()
                    let id = data["id"] as? String ?? ""
                    let sender = data["sender"] as? String ?? ""
                    let receiver = data["receiver"] as? String ?? ""
                    let text = data["text"] as? String ?? ""
                    let image = data["image"] as? String ?? ""
                    let timestamp = data["timestamp"] as? Timestamp
                    
                    return Message(id: id, sender: sender, receiver: receiver, text: text, image: image, timestamp: timestamp)
                }
            }
    }
    
    func sendData(to: String, text: String, image: String = "") {
        
        if chatId.isEmpty {
            self.chatId = createChatId(to: to)
            sendMessage(to: to, text: text, image: image)
        }else {
            sendMessage(to: to, text: text, image: image)
        }
    }
    
    func createChatId(to: String) -> String {
        
        let chats = Chat(
            id: currentUser!.uid+to,
            identifires: [currentUser!.uid+to, to+currentUser!.uid],
            participants: [currentUser!.uid, to]
        )
        
        var create = ""
        
        do {
            create = try db.collection(StoragePath.CHAT.rawValue)
                .addDocument(from: chats)
                .documentID
        }catch {
            print(error)
        }
        
        return create
    }
    
    func sendMessage(to: String, text: String, image: String) {
        
        let batch = db.batch()
        
        let chatRef = db.collection(StoragePath.CHAT.rawValue)
        
        let message = Message(id: UUID().uuidString, sender: currentUser!.uid, receiver: to, text: text, image: image, timestamp: Timestamp(date: Date()))
        
        do {
            try chatRef.document(chatId)
                .collection(StoragePath.MESSAGE.rawValue)
                .addDocument(from: message)
            
            let nestChat = chatRef.document(chatId)
            batch.updateData(["lastText": text, "lastImg": image, "updateAt": Timestamp(date: Date())], forDocument: nestChat)
            batch.commit()
        }catch {
            print(error)
        }
    }
}
