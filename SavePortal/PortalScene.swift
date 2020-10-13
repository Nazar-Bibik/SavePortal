//
//  PortalScene.swift
//  SavePortal
//
//  Created by Nazar on 09/10/2020.
//

import Foundation
import SpriteKit


class PortalScene: SKScene {
    
    private let tileSpeed: TimeInterval = 0.35
    private let panelCountHor: Int = 18
    private let panelCountVer: Int = 10
    private var panelSize: CGSize
    private var animationDelay: TimeInterval = 0
    private var animationTimer: TimeInterval = 0
    private var animationSpeed: Double = 0.075
    private var panels: [[PanelNode]] = [[]]
    let panelTextures: [SKTexture]
    let shadowTexture: SKTexture
    
    private let coloursPanel: [SKColor] = [SKColor(red: 0.988, green: 0.972, blue: 0.950, alpha: 1), SKColor(red: 0.129, green: 0.133, blue: 0.133, alpha: 1)]
    private let colourBack: SKColor = SKColor(red: 31/255, green: 32/255, blue: 33/255, alpha: 1)
    private let colourFrame: SKColor = SKColor(red: 120/255, green: 118/255, blue: 116/255, alpha: 1)
    private let colourBackground: SKColor = SKColor(red: 31/255, green: 32/255, blue: 33/255, alpha: 1)

    
    override init(size: CGSize) {
        panelSize = CGSize(width: size.width / CGFloat(panelCountHor), height: size.height / CGFloat(panelCountVer))
//        panelTextures = CreatePanelTexture(panelColours: coloursPanel, frameColour: colourFrame, panelSize: panelSize, size: size)
        shadowTexture = SKTexture(imageNamed: "shadow")
        var imageURL = Bundle.main.url(forResource: "gradient", withExtension: "png")
        let imageGradient = NSImage(contentsOf: imageURL!)!
//        self.panelTextures = [SKTexture(imageNamed: "shadow"), SKTexture(imageNamed: "polka")]
        self.panelTextures = [SKTexture(image: imageGradient), SKTexture(image: imageGradient)]
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        backgroundColor = colourBackground
        
        let rotateAction = RotateAction(panelSize: panelSize, tileSpeed: tileSpeed)

        for i in 0 ..< panelCountVer {
            for c in 0..<panelCountHor{
                let scewAction = SkewAction(position: i, height: panelCountVer, tileSpeed: tileSpeed)
                let shadowAction = SKAction.group([ShawdowAction(tileSpeed: tileSpeed), scewAction])
                let flipAction = SKAction.group([scewAction, rotateAction])
                let panel = PanelNode(size: panelSize, flipAction: flipAction, shadowAction: shadowAction, panelTextures: panelTextures)
                let shadow = SKSpriteNode(texture: shadowTexture, size: panelSize)
                shadow.name = "shadow"
                shadow.alpha = 0.0
                shadow.warpGeometry = warpGeometryGridNoWarp
                panel.position = CGPoint(x: CGFloat(c) * panelSize.width + panelSize.width/2, y: CGFloat(i) * panelSize.height + panelSize.height/2)
                panel.warpGeometry = warpGeometryGridNoWarp
                panel.zPosition = 1.9 / CGFloat.pi * CGFloat(asin(sin(Float.pi * Float(i) * 1 / Float(panelCountVer))))
                panel.addChild(shadow)

                
                addChild(panel)
                panels[i].append(panel)
            }
            panels.append([])
        }
        
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if currentTime >= animationDelay{
            animationTimer = currentTime + Double(panelCountHor + panelCountVer - 1) * animationSpeed
            animationDelay = animationTimer + 2
        } else if currentTime < animationTimer {
            animateDiagonalPlan(currentTime: currentTime)
        }
    }
////
//
////        for i in 0..<panelCountVer {
////            for c in 0..<panelCountHor{
//////                if panels[i][c].rot >= tileSpeed{
//////                    panels[i][c].state = false
//////                    panels[i][c].rot = -tileSpeed
//////                }
////                if panels[i][c].state{
//////                    panels[i][c].rot = panels[i][c].rot + 1
//////                    panels[i][c].size.width = panelSize.width * CGFloat(panels[i][c].rot) / CGFloat( tileSpeed)
////                    let group = SKAction.group([rotateAction, panels[i][c].scewAction])
////                    panels[i][c].state = false
//////                    panels[i][c].run(panels[i][c].scewAction)
////                    panels[i][c].childNode(withName: "front")!.run(panels[i][c].scewAction)
////                    panels[i][c].run(group)
////                }
////            }
////        }
//    }
//
//
    func animateDiagonalPlan(currentTime: TimeInterval){
        let step = Int((animationTimer - currentTime) / Double(animationSpeed))
        var hor = step
        for ver in 0..<panelCountVer{
            if hor < panelCountHor && hor >= 0{
                panels[ver][hor].flip()
            }
            hor -= 1
        }
    }
    
}
