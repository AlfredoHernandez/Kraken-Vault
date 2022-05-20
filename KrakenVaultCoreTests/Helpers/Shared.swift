//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

func anyNSError() -> Error {
    NSError(domain: "io.alfredohdz.testing", code: 0)
}
