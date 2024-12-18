import SwiftUI
import FirebaseAuth

struct PhoneAuthView: View {
    @State private var phoneNumber: String = ""
    @State private var verificationCode: String = ""
    @State private var verificationID: String? = nil
    @State private var isAuthenticated: Bool = false
    @AppStorage("isRegistered") private var isRegistered: Bool = false
    @State private var navigateToChatsList: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()

                VStack {
                    Text("Phone Authentication")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top, 60)

                    Spacer()

                    if !isRegistered {
                        VStack(spacing: 20) {
                            TextField("Enter phone number", text: $phoneNumber)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 10)
                                .keyboardType(.phonePad)
                                .padding(.horizontal, 24)

                            Button(action: {
                                sendVerificationCode()
                            }) {
                                Text("Send Verification Code")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 10)
                                    .padding(.horizontal, 24)
                            }

                            TextField("Enter verification code", text: $verificationCode)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 10)
                                .keyboardType(.numberPad)
                                .padding(.horizontal, 24)

                            Button(action: {
                                verifyCode()
                            }) {
                                Text("Verify Code")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 10)
                                    .padding(.horizontal, 24)
                            }
                        }
                        .padding(.top, 30)
                    }

                    if isRegistered {
                        Text("You are authenticated!")
                            .font(.headline)
                            .foregroundColor(.green)
                            .padding(.top, 30)
                    }

                    Spacer()
                }
            }
            .onAppear {
                checkAuthenticationStatus()
            }
            .background(
                NavigationLink(destination: ChatsListView(), isActive: $navigateToChatsList) {
                    EmptyView()
                }
            )
        }
    }

    // MARK: - Updated Send Verification Code
    func sendVerificationCode() {
        let phoneNumberWithPrefix = "+39" + phoneNumber

        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumberWithPrefix, uiDelegate: nil) { verificationID, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error sending verification code: \(error.localizedDescription)")
                        return
                    }

                    if let verificationID = verificationID {
                        self.verificationID = verificationID
                        print("Success: Verification ID - \(verificationID)")
                    } else {
                        print("Error: Verification ID is nil!")
                    }
                }
            }
    }

    // MARK: - Verify Code
    func verifyCode() {
        guard let verificationID = self.verificationID, !verificationCode.isEmpty else {
            print("Invalid verification ID or verification code")
            return
        }

        let credential = PhoneAuthProvider.provider()
            .credential(withVerificationID: verificationID, verificationCode: verificationCode)

        Auth.auth().signIn(with: credential) { authResult, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error verifying code: \(error.localizedDescription)")
                    return
                }

                self.isAuthenticated = true
                self.isRegistered = true
                print("User authenticated successfully!")

                self.navigateToChatsList = true
            }
        }
    }

    // MARK: - Check Authentication Status
    func checkAuthenticationStatus() {
        if let user = Auth.auth().currentUser {
            self.isAuthenticated = true
            self.isRegistered = true
            print("User is already authenticated: \(user.phoneNumber ?? "")")
            self.navigateToChatsList = true
        } else {
            self.isAuthenticated = false
            print("User is not authenticated.")
        }
    }
}

struct PhoneAuthView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneAuthView()
            .previewDevice("iPhone 13")
    }
}
