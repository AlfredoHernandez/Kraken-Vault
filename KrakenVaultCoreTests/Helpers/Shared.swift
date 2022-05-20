//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

func anyNSError() -> Error {
    NSError(domain: "io.alfredohdz.testing", code: 0)
}

extension UUID {
    static let fake = UUID(uuidString: "a19f88f1-8cd6-4cc2-bf4a-675c628f20fb")!
}
