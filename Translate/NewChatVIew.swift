import SwiftUI

struct NewChatView: View {
    @Environment(\.dismiss) var dismiss
    @State private var recipient = ""
    @State private var message = ""

    var body: some View {
        ZStack{
            // "To:" Field
            VStack(spacing: 0) {
                HStack {
                    Text("To:")
                        .foregroundColor(.gray)
                        .padding(.leading, 16)
                    TextField("Enter name or number", text: $recipient)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .frame(height: 50)
                Divider() // Thin line below "To:" field
            }
            .offset(y:-300)
            
            Spacer() // White space between fields

            // Message Input Field at Bottom
            VStack(spacing: 0) {
                Divider() // Thin line above the input box
                HStack {
                    TextField("Type your message", text: $message)
                        .padding(12)

                    // Send button (green arrow)
                    Button(action: {
                        print("Message sent: \(message)")
                        message = ""
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.green)
                    }
                }
                .padding(.horizontal, 8)
            }
            .background(Color(UIColor.systemBackground))
            .frame(height: 50)
            .offset(y: 300)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                // "New Message" title
                Text("New Message")
                    .font(.system(size: 17, weight: .semibold))
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                // Cancel button
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.blue)
            }
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom) // Prevents clipping
    }
}

struct NewChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewChatView()
        }
    }
}
