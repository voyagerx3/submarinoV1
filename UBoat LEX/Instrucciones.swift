//
//  Instrucciones.swift
//  UBoat LEX
//
//  Created by Aitor Peinador on 7/2/15.
//  Copyright (c) 2015 Berganza. All rights reserved.
//

import SpriteKit
import UIKit

class Instrucciones: SKScene {
    
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.whiteColor()
        
        let instruccionesLabel = SKLabelNode(fontNamed: "Avenir")
        instruccionesLabel.text = "Controla tu submarino y destruye todos los barcos enemigos!"
        instruccionesLabel.fontColor = UIColor.blackColor()
        instruccionesLabel.fontSize = 18
        instruccionesLabel.position = CGPoint(x: size.width / 2, y: size.height - 80)
        instruccionesLabel.name = "Instrucciones"
        
        let volverLabel = SKLabelNode(fontNamed: "Avenir")
        volverLabel.text = "Volver"
        volverLabel.fontColor = UIColor.blackColor()
        volverLabel.fontSize = 22
        volverLabel.position = CGPoint(x: size.width / 2, y: 20)
        volverLabel.name = "Volver"

        addChild(instruccionesLabel)
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