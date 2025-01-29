//
//  ContentView.swift
//  Prototype_Ch4-Loukeys Watch App
//
//  Created by Daniele Fontana on 29/01/25.
//

import SwiftUI
import UserNotifications
import AVFoundation

struct ContentView: View {
    @State private var taskCompleted = false
    @State private var player: AVAudioPlayer?
    
    var body: some View {
        VStack {
            Text("Prendi la pillola")
                .font(.headline)
                .padding()
            
            if taskCompleted {
                Text("Completato! ✅")
                    .foregroundColor(.green)
                    .font(.subheadline)
            } else {
                Button(action: {
                    taskCompleted = true
                    playSound()
                    scheduleNotification()
                }) {
                    Text("Segna come fatto")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
    
    
    
    func playSound() {
        if let soundURL = Bundle.main.url(forResource: "success", withExtension: "wav") {
            do {
                player = try AVAudioPlayer(contentsOf: soundURL)
                player?.play()
            } catch {
                print("Errore nella riproduzione del suono: \"(error) /")
            }
        }
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Promemoria"
        content.body = "Ricorda di prendere la pillola!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}


#Preview {
    ContentView()
}
