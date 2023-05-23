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
    
    // Define the available actions
    let actions = [
        Action(name: "Eat", cost: 10, effects: [Effect(type: .hunger, value: 10)]),
        Action(name: "Drink", cost: 5, effects: [Effect(type: .thirst, value: 10)]),
        Action(name: "Entertainment", cost: 15, effects: [Effect(type: .entertainment, value: 30)]),
        Action(name: "Watch Movies", cost: 25, effects: [Effect(type: .entertainment, value: 40), Effect(type: .hunger, value: 5)])
    ]
    
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
                
                // Table view for actions
                List(actions, id: \.name) { action in
                    Button("\(action.name) ($\(action.cost))") {
                        performAction(action)
                    }
                }
                
                Button("Sleep") {
                    person.energy += 10
                    person.hunger -= 10
                    person.thirst -= 10
                }
                Button(action: workButtonAction) {
                    if workCooldown {
                        Text("Work (Cooldown)")
                            .foregroundColor(.gray)
                            .disabled(true)
                    } else {
                        Text("Work (+$15)")
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
    
    struct Action: Identifiable {
        let id = UUID()
        let name: String
        let cost: Int
        let effects: [Effect]
    }
    
    struct Effect {
        let type: NeedType
        let value: Int
    }
    
    enum NeedType {
        case hunger
        case thirst
        case entertainment
    }
    
    func performAction(_ action: Action) {
        if person.money >= action.cost {
            person.money -= action.cost
            for effect in action.effects {
                switch effect.type {
                case .hunger:
                    person.hunger += effect.value
                case .thirst:
                    person.thirst += effect.value
                case .entertainment:
                    person.entertainment += effect.value
                }
            }
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
    
    func startNewGame() {
            person.hunger = 100
            person.thirst = 100
            person.entertainment = 100
            person.energy = 100
            person.money = 0
        }
    var menu: some View {
        Menu {
            Button("Start New Game") {
                // Code for starting a new game
                startNewGame()
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
