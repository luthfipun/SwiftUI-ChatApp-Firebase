//
//  HomeViewModel.swift
//  ChatApp
//
//  Created by Luthfi Abdul Azis on 15/03/21.
//

import Foundation
import Firebase

class HomeViewModel: ObservableObject {
    @Published var loading: Bool = false
    @Published var contactList = [User]()
    @Published var recents = [Recent]()
    
    
    private let db = Firestore.firestore()
    private let currentUser = Auth.auth().currentUser
    
    init() {
        getContactList()
        getRecent()
    }
}

extension HomeViewModel {
    
    func getContactList() {
        loading.toggle()
    
        let id = currentUser?.uid
        db.collection(StoragePath.USER.rawValue)
            .whereField("id", isNotEqualTo: id as Any)
            .addSnapshotListener { querySnapshot, error in
                self.loading.toggle()
                
                guard let documents = querySnapshot?.documents else {
                    print("No Data")
                    return
                }
                
                self.contactList = documents.map { queryDocumentSnapshot -> User in
                    let data = queryDocumentSnapshot.data()
                    let id = data["id"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let photo = data["photo"] as? String ?? ""
                    let timestamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
                    
                    return User(id: id, name: name, email: email, photo: photo, timestamp: timestamp)
                }
            }
    }
    
    func getRecent() {
        let id = currentUser!.uid
        let chatRef = db.collection(StoragePath.CHAT.rawValue)
        let listRecents = chatRef.whereField("participants", arrayContains: id)
        listRecents.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No data")
                return
            }
            
            self.recents = documents.map { document in
                
                let data = document.data()
                let recentId = data["id"] as? String ?? ""
                let text = data["lastText"] as? String ?? ""
                let image = data["lastImg"] as? String ?? ""
                let timestamp = data["updateAt"] as? Timestamp
                let participants = data["participants"] as? [String] ?? []
                let participantsId = participants.filter { val in val != id }[0]
                let receiver = self.contactList.filter{ val in val.id == participantsId }[0]
                
                return Recent(id: recentId, user: receiver, text: text, image: image, timestamp: timestamp)
            }
            .filter({ val in !val.text.isEmpty })
            .sorted(by: { res1, res2 -> Bool in
                return (res1.timestamp?.dateValue().timeIntervalSinceNow)! > (res2.timestamp?.dateValue().timeIntervalSinceNow)!
            })
        }
    }
}
