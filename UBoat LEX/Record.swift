//
//  Record.swift
//  UBoat LEX
//
//  Created by Aitor Peinador on 1/2/15.
//  Copyright (c) 2015 Berganza. All rights reserved.
//

import SpriteKit
import UIKit

class Record: SKScene {
    
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.whiteColor()
        let volverLabel = SKLabelNode(fontNamed: "Avenir")
        volverLabel.text = "Volver"
        volverLabel.fontColor = UIColor.blackColor()
        volverLabel.fontSize = 22
        volverLabel.zPosition = 3
        volverLabel.position = CGPoint(x: size.width / 2, y: 20)
        volverLabel.name = "Volver"
        
        let ejemploRecordLabel = SKLabelNode(fontNamed: "Avenir")
        ejemploRecordLabel.text = "1. APC 18.000ptos"
        ejemploRecordLabel.fontColor = UIColor.blackColor()
        ejemploRecordLabel.fontSize = 18
        ejemploRecordLabel.zPosition = 3
        ejemploRecordLabel.position = CGPoint(x: size.width / 2, y: size.height - 100)
        ejemploRecordLabel.name = "Records"
        
        addChild(ejemploRecordLabel)
        addChild(volverLabel)
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let tocarLabel: AnyObject = touches.anyObject()!
        let posicionTocar = tocarLabel.locationInNode(self)
        let loQueTocamos = self.nodeAtPoint(posicionTocar)
        
        if loQueTocamos.name == "Volver" {
            let transicion = SKTransition.revealWithDirection(SKTransitionDirection.Right, duration: 2)
            let  aparecerEscena = Menu(size: self.size)
            aparecerEscena.scaleMode = SKSceneScaleMode.AspectFill
            self.scene?.view?.presentScene(aparecerEscena, transition: transicion)
        }
    }
}