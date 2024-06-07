//
//  Application.swift
//  Template
//
//  Created by Mateusz Bunkowski on 6/6/24.
//

import SwiftUI

@main
struct Application {
    static func main() {
        let sendEvent = class_getInstanceMethod(UIApplication.self, #selector(UIApplication.sendEvent))!
        let customSendEvent = class_getInstanceMethod(UIApplication.self, #selector(UIApplication.sendEventSwizzled))!
        method_exchangeImplementations(sendEvent, customSendEvent)

        TemplateApp.main()
    }
}

extension Notification.Name {
    static let userActivity = Notification.Name("user-activity")
}

extension UIApplication {
    @objc dynamic func sendEventSwizzled(_ event: UIEvent) {
        sendEventSwizzled(event)
        NotificationCenter.default.post(name: .userActivity, object: nil)
    }
}
