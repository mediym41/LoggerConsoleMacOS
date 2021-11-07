//
//  SettingsView.swift
//  Console
//
//  Created by Дмитрий Пащенко on 04.11.2021.
//

import SwiftUI
import Combine






class SettingsViewModel: ObservableObject {
    // MARK: Services
    let storage: SettingsStorage = .init()
    @Published var host: String
    @Published var port: String
    var status: String
    var errorMessage: String?
    var connectionStatusSubscription: Cancellable?
    
    init() {
        host = storage.host
        port = storage.port
        status = ""
        errorMessage = nil
        connectionStatusSubscription = Server.shared.$status.sink { [weak self] status in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.objectWillChange.send()
                switch status {
                case .inactive:
                    self.status = "Inactive"
                    self.errorMessage = nil
                case .waiting:
                    self.status = "Waiting for connection"
                    self.errorMessage = nil
                case .connected:
                    self.status = "Connected"
                    self.errorMessage = nil
                case .failed(let message):
                    self.status = "Failed"
                    self.errorMessage = message
                }
            }
        }
    }
    
    func rehostButtonPressed() {
        storage.host = host
        storage.port = port
        Server.shared.reload()
    }
}

struct SettingsView: View {
    
    @ObservedObject var viewModel: SettingsViewModel = .init()
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Spacer()
                Text("Settings")
                    .font(.museoCyrl(.bold, size: 15))
                Spacer()
            }
            .padding(.top, 12)
            .padding(.bottom, 8)
            .background(Palette.Container.common)
            .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
            
            // MARK: - Server settings block
            VStack(spacing: 12) {
                HStack {
                    Text("Connection")
                        .font(.museoCyrl(.bold, size: 14))
                    Spacer()
                    Button(action: {
                        viewModel.rehostButtonPressed()
                    }) {
                        Text("Rehost")
                            .padding(.horizontal, 5)
                            .contentShape(Rectangle())
                            .foregroundColor(.white)
                            .font(.museoCyrl(.regular, size: 13))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 5)
                    .padding(.vertical, 2)
                    .background(Palette.buttonSelection)
                    .cornerRadius(5)
                }
                HStack {
                    VStack {
                        Text("Host")
                            .font(.museoCyrl(.medium, size: 13))
                        TextField("Host", text: $viewModel.host)
                            .textFieldStyle(PlainTextFieldStyle())
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .background(Palette.TextInput.background)
                            .cornerRadius(8)
                    }
                    .padding(8)
                    .background(Palette.Container.nested)
                    .cornerRadius(8)
                    
                    VStack {
                        Text("Port")
                            .font(.museoCyrl(.medium, size: 13))
                        TextField("Port", text: $viewModel.port)
                            .textFieldStyle(PlainTextFieldStyle())
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .background(Palette.TextInput.background)
                            .cornerRadius(8)
                    }
                    .padding(8)
                    .background(Palette.Container.nested)
                    .cornerRadius(8)
                }
                
                HStack {
                    Spacer()
                    Text("Status: \(viewModel.status)")
                        .font(.museoCyrl(.bold, size: 13))
                        .padding(.leading, 10)
                    Spacer()
                }
                .padding(8)
                .background(Palette.Container.nested)
                .cornerRadius(8)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.museoCyrl(.medium, size: 13))
                        .padding(10)
                    Spacer()
                }
            }
            .padding(12)
            .background(Palette.Container.common)
            .cornerRadius(10)
            
            Spacer()
        }
        .padding(.horizontal, 10)
        .edgesIgnoringSafeArea(.top)
    }
}

