//
//  Enemy.swift
//  UBoat LEX
//
//  Created by Aitor Peinador on 10/1/15.
//  Copyright (c) 2015 Berganza. All rights reserved.
//

import Spritekit

class Enemy: SKSpriteNode {
    /*
    var posicionX: CGFloat = 0.0
    var posicionY: CGFloat = 0.0
    var posicionZ: CGFloat = 0.0
    var escala: CGFloat = 0.0
    */
    
    let tipos = ["enemigo-1","enemigoGerman","enemigoFrance","enemigoArg","enemigoCol"]
    
    convenience override init() {
        self.init(imageNamed:"enemigo-1")
        
    }
}