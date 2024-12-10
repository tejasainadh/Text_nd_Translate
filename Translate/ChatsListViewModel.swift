//
//  ChatsListViewModel.swift
//  Translate
//
//  Created by Tejsainadh on 09/12/24.
//

import Foundation
import SwiftUI

struct ChatOverview: Identifiable {
    let id: UUID
    let contactNameOrNumber: String
    let lastMessage: String

    init(contactNameOrNumber: String, lastMessage: String) {
        self.id = UUID()
        self.contactNameOrNumber = contactNameOrNumber
        self.lastMessage = lastMessage
    }
}
