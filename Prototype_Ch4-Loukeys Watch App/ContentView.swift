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
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        ZStack {
            (taskCompleted ? Color.green : Color.black)
                .ignoresSafeArea()
                .onTapGesture {
                    if taskCompleted {
                        taskCompleted = false
                    }
                }
            
            VStack {
                Image(systemName: "pills")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                Text("Prendi la pillola")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .onAppear {
                        speakTask()
                    }
                
                if taskCompleted {
                    Text("Completato! ✅")
                        .foregroundColor(.black)
                        .font(.subheadline)
                        .onAppear {
                            congratulateUser()
                        }
                } else {
                    Button(action: {
                        taskCompleted = true
                        playSound()
                        scheduleNotification()
                    }) {
                        Text("Segna come fatto")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
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
                print("Errore nella riproduzione del suono: \(error)")
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
    
    func speakTask() {
        let voices = AVSpeechSynthesisVoice.speechVoices()
        
        if let voice = voices.first(where: { $0.language == "it-IT" }) {
            let utterance = AVSpeechUtterance(string: "Prendi la pillola")
            utterance.voice = voice
            utterance.rate = AVSpeechUtteranceDefaultSpeechRate
            utterance.pitchMultiplier = 1.2
            speechSynthesizer.speak(utterance)
        }
    }
    

    func congratulateUser() {
        let utterance = AVSpeechUtterance(string: "Complimenti!")
        utterance.voice = AVSpeechSynthesisVoice(language: "it-IT")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.pitchMultiplier = 1.2 
        speechSynthesizer.speak(utterance)
    }
}

#Preview {
    ContentView()
}

