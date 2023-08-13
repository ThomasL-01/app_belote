//
//  ContentView.swift
//  App_Belote
//
//  Created by Tom Loulou on 13/08/2023.
//

import SwiftUI

struct PointsCounterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var score1 = 0
    @State private var score2 = 0
    @State private var isAddingPoints = false
    @State private var selectedTeam = 0
    @State private var userScoreInput = ""
    @State private var isBeloteTeam1 = false
    @State private var isBeloteTeam2 = false
    @State private var teamName1 = "Equipe 1"
    @State private var teamName2 = "Equipe 2"
    @State private var isSettingUpTeams = true

    var body: some View {
            
        VStack(spacing: 20) {
            Text("Compteur de points")
                .font(.title)
                .padding(.top, 20)
            
            if isSettingUpTeams {
                TextField("Nom de l'équipe 1", text: $teamName1)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                TextField("Nom de l'équipe 2", text: $teamName2)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }
            
            HStack {
                Text("\(teamName1)")
                    .font(.headline)
                    .foregroundColor(.green)
                Text("\(teamName2)")
                    .font(.headline)
                    .foregroundColor(.green)
            }
            
            
            HStack {
                Text("\(score1)")
                    .font(.largeTitle)
                Text("\(score2)")
                    .font(.largeTitle)
            }
            
            Button("Manche suivante") {
                isAddingPoints.toggle()
                if isAddingPoints {
                    isSettingUpTeams = false
                }
            }
            .disabled(isAddingPoints)
            .padding()
            
            if isAddingPoints {
                VStack(spacing: 20) {
                    Text("Y a-t-il belote pour l'équipe \(teamName1)?")
                    Toggle("", isOn: $isBeloteTeam1)
                        .labelsHidden()
                        .onChange(of: isBeloteTeam1) { newValue in
                            if newValue {
                                isBeloteTeam2 = false
                            }
                        }
                    
                    Text("Y a-t-il belote pour l'équipe \(teamName2)?")
                    Toggle("", isOn: $isBeloteTeam2)
                        .labelsHidden()
                        .onChange(of: isBeloteTeam2) { newValue in
                            if newValue {
                                isBeloteTeam1 = false
                            }
                        }
                    
                    Picker(selection: $selectedTeam, label: Text("Équipe")) {
                        Text("\(teamName1)").tag(0)
                        Text("\(teamName2)").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    TextField("Score", text: $userScoreInput)
                        .frame(width: 200, height: 30)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Valider") {
                        validate()
                        isAddingPoints.toggle()
                    }
                }
                .padding()
                .border(Color.black, width: 1)
            }
            
            if !isAddingPoints {
                Button("Réinitialiser les scores") {
                    score1 = 0
                    score2 = 0
                    isSettingUpTeams = true
                }
            }
        }
        .padding()
    }

    private func validate() {
        guard let score = Int(userScoreInput), score >= 0, (score == 252 || score <= 162) else {
            return // Ignore invalid score inputs
        }
        
        let beloteBonus = 20
        let winScore = 252

        if isBeloteTeam1 {
            score1 += beloteBonus
        }
        if isBeloteTeam2 {
            score2 += beloteBonus
        }

        if selectedTeam == 0 {
            if score == winScore {
                score1 += winScore
            } else if score <= 162 {
                score1 += score
                score2 += 162 - score
            }
        } else {
            if score == winScore {
                score2 += winScore
            } else if score <= 162 {
                score2 += score
                score1 += 162 - score
            }
        }
        userScoreInput = ""
    }
}
