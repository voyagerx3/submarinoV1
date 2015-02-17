//
//  GameOver.swift
//  UBoat LEX
//
//  Created by Aitor Peinador on 17/2/15.
//  Copyright (c) 2015 Berganza. All rights reserved.
//

import SpriteKit
import UIKit

class GameOver: SKScene {
    
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.whiteColor()
        
        let gameOverLabel = SKLabelNode(fontNamed: "Avenir")
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.fontColor = UIColor.blackColor()
        gameOverLabel.fontSize = 30
        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height - 80)
        gameOverLabel.name = "GameOver"
        
        let volverJugarLabel = SKLabelNode(fontNamed: "Avenir")
        volverJugarLabel.text = "Volver a jugar"
        volverJugarLabel.fontColor = UIColor.blackColor()
        volverJugarLabel.fontSize = 22
        volverJugarLabel.position = CGPoint(x: size.width / 2 - 80, y: 20)
        volverJugarLabel.name = "VolverJugar"
        
        let volverMenuLabel = SKLabelNode(fontNamed: "Avenir")
        volverMenuLabel.text = "Menu Principal"
        volverMenuLabel.fontColor = UIColor.blackColor()
        volverMenuLabel.fontSize = 22
        volverMenuLabel.position = CGPoint(x: size.width / 2 + 80, y: 20)
        volverMenuLabel.name = "VolverMenu"
        
        addChild(gameOverLabel)
        addChild(volverJugarLabel)
        addChild(volverMenuLabel)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let tocarLabel: AnyObject = touches.anyObject()!
        let posicionTocar = tocarLabel.locationInNode(self)
        let loQueTocamos = self.nodeAtPoint(posicionTocar)
        
        if loQueTocamos.name == "VolverJugar" {
            let transicion = SKTransition.revealWithDirection(SKTransitionDirection.Right, duration: 2)
            let  aparecerEscena = Juego(size: self.size)
            aparecerEscena.scaleMode = SKSceneScaleMode.AspectFill
            self.scene?.view?.presentScene(aparecerEscena, transition: transicion)
        } else if loQueTocamos.name == "VolverMenu" {
            let transicion = SKTransition.revealWithDirection(SKTransitionDirection.Right, duration: 2)
            let  aparecerEscena = Menu(size: self.size)
            aparecerEscena.scaleMode = SKSceneScaleMode.AspectFill
            self.scene?.view?.presentScene(aparecerEscena, transition: transicion)
        }
    }
}