//
//  EmptyTaskView.swift
//  TestDo
//
//  Created by Keshu Rai on 25/09/23.
//

import SwiftUI

struct EmptyTaskView: View {
    
    var action : () -> ()
    
    var body: some View {
        
        VStack {
            Spacer()
            Image(systemName: "scribble")
                .resizable()
                .frame(width: 80,height: 80)
                .foregroundColor(.gray)
            Text("Uh oh! Its Empty Here. Add Some Tasks for Today.")
                .padding(50)
                .multilineTextAlignment(.center)
            AppButton(title: "Add New Task", action: action)
            Spacer()
        }
    }
}

struct EmptyTaskView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyTaskView(action: {})
    }
}
