//
//  Logger.swift
//  Buildio
//
//  Created by Sergey Khliustin on 04.10.2021.
//

import Foundation
import SwiftyBeaver

// direct access to the logger across the app
let logger: SwiftyBeaver.Type = {
    if !SwiftyBeaver.destinations.contains(where: { $0 is ConsoleDestination }) {
        let console = ConsoleDestination()
        console.asynchronously = false
        console.format = "$DHH:mm:ss.SSS$d $C$L$c $N.$F:$l - $X - \n $M"
        //    console.levelColor.verbose = "⚪️ "
        //    console.levelColor.debug = "☑️ "
        //    console.levelColor.info = "🔵 "
        //    console.levelColor.warning = "🔶 "
        //    console.levelColor.error = "🔴 "
#if !DEBUG
        console.minLevel = .info
#endif
        
        SwiftyBeaver.addDestination(console)
    }
    return SwiftyBeaver.self
}()
