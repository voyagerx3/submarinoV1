//
//  Volar.swift
//  UBoat LEX
//
//  Created by Geovanny Inca on 16/02/15.
//  Copyright (c) 2015 Berganza. All rights reserved.
//

import Foundation
import SpriteKit
class Volar: SKScene, SKPhysicsContactDelegate {
    
    var puntosLabel = SKLabelNode()
    var puntosTotales: Int = 0
    var vidaLabel = SKLabelNode()
    var anchoScreen: CGFloat = UIScreen.mainScreen().bounds.width
    var altoScreen: CGFloat = UIScreen.mainScreen().bounds.height

    var submarino: SKSpriteNode!
    var submarinoAtlas = SKTextureAtlas(named: "sub")
    var submarinoFrames = [SKTexture]()
    
    let velocidadFondo: CGFloat = 2
    
    override func didMoveToView(view: SKView) {
        heroe01()
        crearEscenario()
        hub()
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
    func crearEscenario() {
//        for var indice = 0; indice < 2; ++indice {
//            let fondo = SKSpriteNode(imageNamed: "sea01v02")
//            fondo.position = CGPoint(x: indice * Int(fondo.size.width), y: 0)
//            fondo.name = "fondo"
//            fondo.zPosition = 0
//            addChild(fondo)
//        }
        let fondo = SKSpriteNode(imageNamed: "sea01v02")
        fondo.position = CGPoint(x: size.width/2, y: size.height/2)
        fondo.name = "fondo"
        fondo.zPosition = 0
        addChild(fondo)

    }
    func hub() {
        // Tira superior donde estan la vida y los puntos
        let fondoHub = SKSpriteNode(imageNamed: "hub")
        fondoHub.setScale(0.5)
        fondoHub.zPosition = 2
        fondoHub.position = CGPoint(x: size.width/2, y: size.height)
        fondoHub.name = "hub"
        
        // Label de vida
        let vidaTexto = SKLabelNode(fontNamed: "Avenir")
        vidaTexto.text = "Vida: "
        vidaTexto.fontColor = UIColor.whiteColor()
        vidaTexto.fontSize = 22
        vidaTexto.zPosition = 3
        vidaTexto.position = CGPoint(x: 40, y: size.height - 20)
        vidaTexto.name = "VidaTexto"
        
        // Contador de vida
        vidaLabel = SKLabelNode(fontNamed: "Avenir")
        //"100%" + self.anchoScreen.description
        vidaLabel.text = "100%"
        vidaLabel.fontColor = UIColor.whiteColor()
        vidaLabel.fontSize = 22
        vidaLabel.zPosition = 3
        vidaLabel.position = CGPoint(x: vidaTexto.position.x + 55, y: size.height - 20)
        vidaLabel.name = "Puntos"
        
        // Label de puntos
        let puntosTexto = SKLabelNode(fontNamed: "Avenir")
        //
        puntosTexto.text = "Puntos: "
        puntosTexto.fontColor = UIColor.whiteColor()
        puntosTexto.fontSize = 22
        puntosTexto.zPosition = 3
        puntosTexto.position = CGPoint(x: size.width - 80, y: size.height - 20)
        puntosTexto.name = "PuntosTexto"
        
        // Contador de puntos
        puntosLabel = SKLabelNode(fontNamed: "Avenir")
        //self.altoScreen.description
        puntosLabel.text =  "0"
        puntosLabel.fontColor = UIColor.whiteColor()
        puntosLabel.fontSize = 22
        puntosLabel.zPosition = 3
        puntosLabel.position = CGPoint(x: puntosTexto.position.x + 50, y: size.height - 20)
        puntosLabel.name = "Puntos"
        
        // Boton de disparo
//        botonDisparo = SKSpriteNode(imageNamed: "firebutton")
//        botonDisparo.setScale(0.5)
//        botonDisparo.zPosition = 3
//        botonDisparo.position = CGPoint(x: size.width - 80, y: 50)
//        botonDisparo.name = "fire"
        
        addChild(vidaTexto)
        addChild(vidaLabel)
        addChild(puntosTexto)
        addChild(puntosLabel)
//        addChild(botonDisparo)
        addChild(fondoHub)
    }
 
    func heroe01() {
        
                var nombreTextura = [NSArray].self
                var totalImgs = submarinoAtlas.textureNames.count
                for var x = 1; x < totalImgs; x++
                {
                    var textureName = "sub\(x)"
                    var texture = submarinoAtlas.textureNamed(textureName)
                    submarinoFrames.append(texture)
                }
        submarino=SKSpriteNode(texture: submarinoFrames[0])
        //       explosion.position=CGPointMake(x,y)
        addChild(submarino)
        submarino.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(submarinoFrames, timePerFrame: 0.4, resize: false, restore: false)))
        
        
        //submarino = SKSpriteNode(imageNamed: "yellowsub")
        submarino.setScale(0.7)
        submarino.zPosition = 1
        submarino.position = CGPointMake(0 - submarino.size.width, 50)
        submarino.name = "heroe01"
        submarino.physicsBody=SKPhysicsBody(circleOfRadius: submarino.size.height/2)
        submarino.physicsBody?.dynamic=true
        submarino.physicsBody?.affectedByGravity=false
        submarino.physicsBody?.allowsRotation=false
//        submarino.physicsBody?.categoryBitMask=categoriasubmarino
//        submarino.physicsBody?.collisionBitMask=categoriahome
//        submarino.physicsBody?.contactTestBitMask=categoriahome
       // addChild(submarino)
    }
    

////
    func vuelosubmarino() {
        self.enumerateChildNodesWithName("heroe01", usingBlock: { (nodo, stop) -> Void in
            if let avion = nodo as? SKSpriteNode {
                avion.position = CGPoint(
                    x: avion.position.x + self.velocidadFondo,
                    y: avion.position.y)
                
                if (avion.position.x  >  (self.anchoScreen+avion.size.width/3)) {
                    avion.position = CGPointMake(-5,avion.position.y)
                }
            }
        })
    

    
    

        
        
}

    override func update(currentTime: NSTimeInterval) {
        //scrollHorizontal()
        //  vuelohorizontal()
        vuelosubmarino()
        // vuelobomba()
        
    }
    
    
}