//
//  Menu.swift
//  UBoat LEX
//
//  Created by Berganza on 16/12/2014.
//  Copyright (c) 2014 Berganza. All rights reserved.
//

import SpriteKit

class Menu: SKScene {
    
    var fondo = SKSpriteNode()

    override func didMoveToView(view: SKView) {
        imagenPeriscopio()
        seleccionMenu()
    }
    
    func imagenPeriscopio() {
        fondo = SKSpriteNode(imageNamed: "periscopio")
        fondo.position = CGPoint(x: size.width / 2 , y: size.height / 2)
        fondo.size = self.size
        addChild(fondo)
    }
    
    func seleccionMenu() {
        // Probando la nueva rama
        let jugarLabel = SKLabelNode(fontNamed: "Avenir")
        jugarLabel.text = "Jugar"
        jugarLabel.fontColor = UIColor.blackColor()
        jugarLabel.fontSize = 30
        jugarLabel.position = CGPoint(x: size.width / 2 - 100, y: size.height / 2 + 30)
        jugarLabel.name = "Empezar"
        
        let recordsLabel = SKLabelNode(fontNamed: "Avenir")
        recordsLabel.text = "Records"
        recordsLabel.fontColor = UIColor.blackColor()
        recordsLabel.fontSize = 30
        recordsLabel.position = CGPoint(x: size.width / 2 - 100, y: size.height / 2)
        recordsLabel.name = "Puntuacion"

        
        
        let instruccionesLabel = SKLabelNode(fontNamed: "Avenir")
        instruccionesLabel.text = "Instrucciones"
        instruccionesLabel.fontColor = UIColor.blackColor()
        instruccionesLabel.fontSize = 30
        instruccionesLabel.position = CGPoint(x: size.width / 2 - 100, y: size.height / 2 - 30)
        instruccionesLabel.name = "Instrucciones"
        
        let volarLabel = SKLabelNode(fontNamed: "Avenir")
        volarLabel.text = "Volar"
        volarLabel.fontColor = UIColor.blackColor()
        volarLabel.fontSize = 30
        volarLabel.position = CGPoint(x: size.width / 2 - 100, y: size.height / 2 - 60)
        volarLabel.name = "Volar"
        
        addChild(jugarLabel)
        addChild(recordsLabel)
        addChild(instruccionesLabel)
        addChild(volarLabel)
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let tocarLabel: AnyObject = touches.anyObject()!
        let posicionTocar = tocarLabel.locationInNode(self)
        let loQueTocamos = self.nodeAtPoint(posicionTocar)
        
        if loQueTocamos.name == "Empezar" {
            let transicion = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 2)
            let  aparecerEscena = Juego(size: self.size)
            aparecerEscena.scaleMode = SKSceneScaleMode.AspectFill
            self.scene?.view?.presentScene(aparecerEscena, transition: transicion)
        } else if loQueTocamos.name == "Puntuacion" {
            let transicion = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 2)
            let  aparecerEscena = Record(size: self.size)
            aparecerEscena.scaleMode = SKSceneScaleMode.AspectFill
            self.scene?.view?.presentScene(aparecerEscena, transition: transicion)
        } else if loQueTocamos.name == "Instrucciones" {
            let transicion = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 2)
            let  aparecerEscena = Instrucciones(size: self.size)
            aparecerEscena.scaleMode = SKSceneScaleMode.AspectFill
            self.scene?.view?.presentScene(aparecerEscena, transition: transicion)
        } else if loQueTocamos.name == "Volar" {
            let transicion = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 2)
            let  aparecerEscena = Volar(size: self.size)
            aparecerEscena.scaleMode = SKSceneScaleMode.AspectFill
            self.scene?.view?.presentScene(aparecerEscena, transition: transicion)
        }
    
    }
}
