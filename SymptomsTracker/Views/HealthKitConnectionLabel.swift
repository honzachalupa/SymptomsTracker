//
//  HealthKitConnectionLabel.swift
//  SymptomsTracker
//
//  Created by Jan Chalupa on 20.03.2024.
//

import SwiftUI

struct HealthKitConnectionLabel: View {
    var symptom: Symptom
    
    var body: some View {
        if symptom.healthKitType != nil {
            HStack {
                Image("AppleHealthIcon")
                    .resizable()
                    .frame(width: 15, height: 15)
                
                Text("Connected to Health app")
                    .opacity(0.7)
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    HealthKitConnectionLabel(symptom: symptomsMock.first!)
}
