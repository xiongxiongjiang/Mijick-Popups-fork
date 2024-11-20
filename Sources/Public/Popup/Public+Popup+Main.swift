//
//  Public+Popup+Main.swift of MijickPopups
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


import SwiftUI

/**
 The view to be displayed as a popup. It may appear in one of three positions (see **Usage** section).
 ## Optional Methods
 - ``configurePopup(config:)-3ze4``
 - ``onFocus()-6krqs``
 - ``onDismiss()-254h8``
 */
public protocol Popup: View {
    associatedtype Config: LocalConfig

    /**
     Configures the popup.
     See the list of available methods in ``LocalConfigCenter`` and ``LocalConfigVertical``.

    - important: If a certain method is not called here, the popup inherits the configuration from ``GlobalConfigContainer``.
     */
    func configurePopup(config: Config) -> Config

    /**
     Method triggered **every time** a popup is at the top of the stack.
     */
    func onFocus()

    /**
     Method triggered when a popup is dismissed.
     */
    func onDismiss()
}

// MARK: Default Methods Implementation
public extension Popup {
    func configurePopup(config: Config) -> Config { config }
    func onFocus() {}
    func onDismiss() {}
}

// MARK: Available Types
/**
 The view to be displayed as a Top popup.
 
 ## Optional Methods
 - ``Popup/configurePopup(config:)-98ha0``
 - ``Popup/onFocus()-6krqs``
 - ``Popup/onDismiss()-3bufs``
 
 ## Usage
 ```swift
 struct TopPopupExample: TopPopup {
    func onFocus() { print("Popup is now active") }
    func onDismiss() { print("Popup was dismissed") }
    func configurePopup(config: TopPopupConfig) -> TopPopupConfig { config
        .heightMode(.auto)
        .cornerRadius(44)
        .dragDetents([.fraction(1.2), .fraction(1.4), .large])
    }
    var body: some View {
        Text("Hello Kitty")
    }
 }
 ```
 ![TopPopup](https://github.com/Mijick/Assets/blob/main/Framework%20Docs/Popups/top-popup.png?raw=true)
*/
public protocol TopPopup: Popup { associatedtype Config = TopPopupConfig }
public typealias TopPopupConfig = LocalConfigVertical.Top

/**
 The view to be displayed as a Center popup.
 
 ## Optional Methods
 - ``Popup/configurePopup(config:)-3ze4``
 - ``Popup/onFocus()-loq5``
 - ``Popup/onDismiss()-3bufs``
 
 ## Usage
 ```swift
 struct CenterPopupExample: CenterPopup {
    func onFocus() { print("Popup is now active") }
    func onDismiss() { print("Popup was dismissed") }
    func configurePopup(config: CenterPopupConfig) -> CenterPopupConfig { config
        .cornerRadius(44)
        .tapOutsideToDismissPopup(true)
    }
    var body: some View {
        Text("Hello Kitty")
    }
 }
 ```
 ![CenterPopup](https://github.com/Mijick/Assets/blob/main/Framework%20Docs/Popups/centre-popup.png?raw=true)
 */
public protocol CenterPopup: Popup { associatedtype Config = CenterPopupConfig }
public typealias CenterPopupConfig = LocalConfigCenter

/**
 The view to be displayed as a Bottom popup.
 
 # Optional Methods
 - ``Popup/configurePopup(config:)-98ha0``
 - ``Popup/onFocus()-loq5``
 - ``Popup/onDismiss()-254h8``
 
 ## Usage
 ```swift
 struct BottomPopupExample: BottomPopup {
    func onFocus() { print("Popup is now active") }
    func onDismiss() { print("Popup was dismissed") }
    func configurePopup(config: BottomPopupConfig) -> BottomPopupConfig { config
        .heightMode(.auto)
        .cornerRadius(44)
        .dragDetents([.fraction(1.2), .fraction(1.4), .large])
    }
    var body: some View {
        Text("Hello Kitty")
    }
 }
 ```
 ![BottomPopup](https://github.com/Mijick/Assets/blob/main/Framework%20Docs/Popups/bottom-popup.png?raw=true)
 */
public protocol BottomPopup: Popup { associatedtype Config = BottomPopupConfig }
public typealias BottomPopupConfig = LocalConfigVertical.Bottom

struct Bottom_FullscreenPopup<Content: View>: BottomPopup {
    @State private var isFullscreen = false
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                CustomBackButton()
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring()) {
                        isFullscreen.toggle()
                    }
                }) {
                    Image(systemName: isFullscreen ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .padding(.horizontal)
            
            content
        }
        .frame(width: UIScreen.main.bounds.width, height: isFullscreen ? UIScreen.main.bounds.height : UIScreen.main.bounds.height * 0.8)
        .ignoresSafeArea()
    }
    
    func configurePopup(config: BottomPopupConfig) -> BottomPopupConfig {
        config
            .heightMode(.auto)
            .ignoredSafeAreaEdges(.all)
            .enableDragGesture(false)
    }
}
