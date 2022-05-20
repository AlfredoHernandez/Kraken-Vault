//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

struct PasswordVaultItemView: View {
    let siteName: String
    let loginIdentifier: String

    var body: some View {
        HStack {
            Image(systemName: "key")
                .frame(width: 32, height: 32, alignment: .center)
            VStack(alignment: .leading, spacing: 4) {
                Text(siteName)
                    .bold()
                Text(loginIdentifier)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button(action: {}) {
                Image(systemName: "doc.on.doc")
            }
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(.accentColor)
        }
    }
}

struct PasswordVaultItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PasswordVaultItemView(siteName: "facebook.com", loginIdentifier: "AlfredoHdzAlarcon")
                .previewLayout(.sizeThatFits)
            PasswordVaultItemView(siteName: "facebook.com", loginIdentifier: "AlfredoHdzAlarcon")
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
