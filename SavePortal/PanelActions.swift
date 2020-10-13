//
//  PanelActions.swift
//  SavePortal
//
//  Created by Nazar on 10/10/2020.
//

import Foundation
import SpriteKit


internal let warpGeometryGridNoWarp = SKWarpGeometryGrid(columns: 1, rows: 1)


internal func RotateAction(panelSize: CGSize, tileSpeed: TimeInterval) -> SKAction{
    let rotateAction = SKAction.sequence( [
                                            SKAction.scale(to: CGSize(width: -panelSize.width, height: panelSize.height), duration: tileSpeed),
                                            SKAction.scale(to: CGSize(width: panelSize.width, height: panelSize.height), duration: TimeInterval(0))
    ])
    
    rotateAction.timingMode = .linear
    return rotateAction
}


internal func SkewAction(position: Int, height: Int, tileSpeed: TimeInterval) -> SKAction{
    let sourcePositions: [SIMD2<Float>] = [
        SIMD2<Float>(0, 0),   SIMD2<Float>(1, 0),
        SIMD2<Float>(0, 1), SIMD2<Float>(1, 1)
    ]
    // No, height / 2 * n is not stupid, it's easier to change the FOV for scew matrix by changing 'n'
    let scew = (height % 2 != 0) && (height / 2 == position) ? 0 : 0.3 * (2 * Float(position) / Float(height) - 1)
    let upperright = SIMD2<Float>(1, scew)
    let lowerright = SIMD2<Float>(1, 1 + scew)
    let upperleft = SIMD2<Float>(0, -scew)
    let lowerleft = SIMD2<Float>(0, 1 - scew)
    let destinationPositions: [SIMD2<Float>] = [
        upperleft, upperright,
        lowerleft, lowerright
    ]
    
    let warpGeometryGrid = SKWarpGeometryGrid(columns: 1, rows: 1, sourcePositions: sourcePositions, destinationPositions: destinationPositions)
    
    let warp = SKAction.warp(to: warpGeometryGrid, duration: tileSpeed/2)!
    warp.timingMode = .linear
    let unwarp = SKAction.warp(to: warpGeometryGridNoWarp, duration: tileSpeed/2)!
    unwarp.timingMode = .linear
    
    let action = SKAction.sequence([warp, unwarp])
    return action
}

internal func ShawdowAction(tileSpeed: TimeInterval) -> SKAction{
    let actionIn = SKAction.fadeAlpha(to: 0.5, duration: tileSpeed/2)
    let actionOut = SKAction.fadeOut(withDuration: tileSpeed/2)
    
    return SKAction.sequence([actionIn, actionOut])
}

