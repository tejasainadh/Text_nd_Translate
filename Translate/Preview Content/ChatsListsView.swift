//
//  ChatListsView.swift
//  Translate
//
//  Created by Tejsainadh on 09/12/24.
//

import Foundation
import SwiftUI



let sampleChats = [
    ChatOverview(contactNameOrNumber: "Giulia", lastMessage: "Ciao!"),
    ChatOverview(contactNameOrNumber: "Mario Rossi", lastMessage: "See you later!"),
    ChatOverview(contactNameOrNumber: "+39 345 678 9012", lastMessage: "Hello! How are you?")
]

struct ChatsListView: View {
    @State private var isShowingNewChatView = false

    var body: some View {
        NavigationView {
            VStack {
                List(sampleChats) { chat in
                    NavigationLink(destination: ChatView(chatName: chat.contactNameOrNumber)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(chat.contactNameOrNumber)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text(chat.lastMessage)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Messages")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingNewChatView = true
                    }) {
                        Image(systemName: "square.and.pencil") // New Chat Icon
                    }
                }
            }
            .sheet(isPresented: $isShowingNewChatView) {
                NewChatView() // Navigate to NewChatView
            }
        }
    }
}

struct ChatsListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsListView()
    }
}
