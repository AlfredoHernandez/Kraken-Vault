//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

struct PasswordOptionToggle: View {
    let title: String
    let exampleText: String
    let color: Color
    @Binding var option: Bool

    var body: some View {
        Toggle(isOn: $option, label: {
            HStack {
                Text(title)
                Text(exampleText).foregroundColor(color)
            }
        })
    }
}

struct PasswordOptionToggle_Previews: PreviewProvider {
    static var previews: some View {
        PasswordOptionToggle(
            title: "Characters",
            exampleText: "a-z",
            color: .green,
            option: .constant(true)
        )
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
}
