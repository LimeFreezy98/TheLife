//
//  ContentView.swift
//  The Life
//
//  Created by Vasiliy on 5/22/23.
//

import SwiftUI

import SwiftUI

struct Person {
    var name: String
    var money: Int
    var hunger: Int
    var thirst: Int
    var entertainment: Int
    var energy: Int
//    var money: Int
}

struct ContentView: View {
    @State private var person = Person(name: "John Doe", money: 0, hunger: 100, thirst: 100, entertainment: 100, energy: 100)
    @State private var workCooldown = false
    
    let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            VStack {
                // Display the person's needs
                Text("Hunger: \(person.hunger)")
                Text("Thirst: \(person.thirst)")
                Text("Entertainment: \(person.entertainment)")
                Text("Energy: \(person.energy)")
                
                // Display the person's money
                Text("Money: $\(person.money)")
                
                // Buttons for actions
                Button("Eat ($10)") {
                    if person.money >= 10 {
                        person.money -= 10
                        person.hunger += 10
                    }
                }
                Button("Drink ($5)") {
                    if person.money >= 5 {
                        person.money -= 5
                        person.thirst += 10
                    }
                }
                Button("Entertainment ($15)") {
                    if person.money >= 15 {
                        person.money -= 15
                        person.entertainment += 30
                    }
                }
                
                
                
                Button("Sleep") {
                    person.energy += 20
                    person.hunger -= 10
                    person.thirst -= 10
                }
                Button(action: workButtonAction) {
                    if workCooldown {
                        Text("Work (Cooldown)")
                            .foregroundColor(.gray)
                            .disabled(true)
                    } else {
                        Text("Work (+$35)")
                    }
                }
            }
            .onReceive(timer) { _ in
                person.hunger -= 1
                person.thirst -= 2
                person.entertainment -= 5
                person.energy -= 1
            }
            .navigationTitle("The Life")
            .navigationBarItems(trailing: menu)
        }
    }
    
    func workButtonAction() {
        if !workCooldown {
            person.money += 35
            person.hunger -= 5
            person.thirst -= 5
            person.entertainment -= 10
            person.energy -= 10
            workCooldown = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 45) {
                workCooldown = false
            }
        }
    }
    
    var menu: some View {
        Menu {
            Button("Start New Game") {
                // Code for starting a new game
            }
            
            Button("Continue") {
                // Code for continuing the game
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .font(.title)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
