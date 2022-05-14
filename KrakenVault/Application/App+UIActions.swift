//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import UIKit

func copyToPasteboard(_ anyString: [String]) {
    UIPasteboard.general.string = anyString.joined()
}

func generateFeedbackImpact() {
    UIImpactFeedbackGenerator(style: .light)
        .impactOccurred()
}
