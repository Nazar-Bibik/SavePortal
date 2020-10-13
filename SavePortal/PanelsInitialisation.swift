//
//  PanelsInitialisation.swift
//  SavePortal
//
//  Created by Nazar on 10/10/2020.
//

import Foundation
import SpriteKit



internal class PanelNode: SKSpriteNode{
    var side: Int = 0
    let flipAction: SKAction
    let shadowAction: SKAction
    let panelTextures: [SKTexture]
    
    
    init(size: CGSize, flipAction: SKAction, shadowAction: SKAction, panelTextures: [SKTexture]) {
        self.flipAction = flipAction
        self.shadowAction = shadowAction
        self.panelTextures = panelTextures
        super.init(texture: panelTextures[1], color: NSColor.black, size: size)
        }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func flip() {
        self.run(flipAction)
        self.childNode(withName: "shadow")?.run(shadowAction)
    }
    
    
}

internal func CreatePanelTexture(panelColours: [SKColor], frameColour: SKColor, panelSize: CGSize, size: CGSize) -> [SKTexture]{
//    var imageURL = Bundle(for: type(of: self)).image(forResource: "gradient")
//    var imageURL = Bundle.main.url(forResource: "gradient", withExtension: "png")
//    let imageGradient = NSImage(contentsOf: imageURL!)!
    
//    let path = Bundle.main.path(forResource: "gradient", ofType: "png")
//    let url = URL(fileURLWithPath: path!)
//    let image = NSImage(contentsOf: url)
    
//    let bundle = Bundle(for: type(of: self))=
    
    let panel = SKSpriteNode(color: panelColours[0], size: panelSize)
    let frameSize = min(panelSize.width, panelSize.height) * 0.15
    let borderSize = min(size.height, size.width) / 150
    let border = SKSpriteNode(imageNamed: "gradient")
//    let border = SKSpriteNode(texture: SKTexture(image: image!))
    let frame = SKSpriteNode(imageNamed: "gradient")
    panel.anchorPoint = CGPoint(x: 0, y: 0)
    border.position = CGPoint(x: 0, y: 0)
    frame.position = CGPoint(x: frameSize, y: 0)
    border.color = frameColour
    frame.color = panelColours[0]
    border.colorBlendFactor = 1.0
    frame.colorBlendFactor = 1
    border.zPosition = 0.3
    frame.zPosition = 0.2
    frame.name = "frame"
    frame.colorBlendFactor = 1.0
    let rotation = [0, -CGFloat.pi * 0.5, CGFloat.pi * 0.5, CGFloat.pi]
    
    for i in [[0,0], [1,0], [0,1], [1,1]]{
        border.size = CGSize(width: borderSize, height: i[1] == i[0] ? panelSize.height : panelSize.width)
        frame.size = CGSize(width: frameSize, height: (i[1] == i[0] ? panelSize.height : panelSize.width) - borderSize * 2)
        border.position = CGPoint(x: (CGFloat(i[1]) * panelSize.width), y: (CGFloat(i[0]) * panelSize.height))
        frame.position = CGPoint(
            x: (CGFloat(i[1]) * panelSize.width + borderSize * CGFloat(i[1] * -2 + 1)),
            y: (CGFloat(i[0]) * panelSize.height + borderSize * CGFloat(i[0] * -2 + 1))
        )
        border.anchorPoint = CGPoint(x: 0, y: 0)
        frame.anchorPoint = CGPoint(x: 0, y: 0)
        border.zRotation = rotation[i[1]*2 + i[0]]
        frame.zRotation = rotation[i[1]*2 + i[0]]
        panel.addChild(border.copy() as! SKNode)
        panel.addChild(frame.copy() as! SKNode)
    }
    
    let mask = SKSpriteNode(color: SKColor.black, size: CGSize(width: panel.size.width - borderSize * 2, height: panel.size.height - borderSize * 2))
    mask.anchorPoint = CGPoint(x: 0, y: 0)
    mask.position = CGPoint(x: borderSize, y: borderSize)
    
    let pattern = SKSpriteNode()
    let patternImage = SKTexture(imageNamed: "polka")
    pattern.texture = patternImage
    pattern.size = patternImage.size()
    pattern.anchorPoint = CGPoint(x: 0, y: 0)
    pattern.position = CGPoint(x: 0, y: 0)
    pattern.alpha = 0.025
    pattern.name = "pattern"

    let cropNode = SKCropNode()
    cropNode.addChild(pattern)
    cropNode.maskNode = mask
    cropNode.zPosition = 0.1
    
    panel.addChild(cropNode)
    
    let output1 = SKView().texture(from: panel, crop: CGRect(origin: CGPoint(x: 0, y: 0), size: panelSize))

    panel.color = panelColours[1]
    panel.enumerateChildNodes(withName: "frame"){
        node , _ in
        (node as? SKSpriteNode)?.color = panelColours[1]
        (node as? SKSpriteNode)?.colorBlendFactor = 1.0
    }
    
    panel.enumerateChildNodes(withName: "//pattern"){
        node , _ in
        (node as? SKSpriteNode)?.texture = SKTexture(imageNamed: "strips")
        (node as? SKSpriteNode)?.alpha = 0.015
    }

    let output2 = SKView().texture(from: panel, crop: CGRect(origin: CGPoint(x: 0, y: 0), size: panelSize))
    
    
    return [output1!, output2!]
}
