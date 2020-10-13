//
//  SavePortal.swift
//  SavePortal
//
//  Created by Nazar on 09/10/2020.
//

import Foundation
import ScreenSaver
import SpriteKit

class SavePortal: ScreenSaverView{
    
    var portalScene: PortalScene?
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        
//        for subview in self.subviews {
//            subview.removeFromSuperview()
//        }

        let view: SKView = SKView(frame: self.bounds)

        portalScene = PortalScene(size: self.bounds.size)
//        portalScene!.scaleMode = .aspectFill
        view.presentScene(portalScene)

        //add it in as a subview
        self.addSubview(view)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
}
