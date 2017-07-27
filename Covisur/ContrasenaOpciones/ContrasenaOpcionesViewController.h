//
//  ContrasenaOpcionesViewController.h
//  Covisur
//
//  Created by Christian Fernandez on 7/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContrasenaOpcionesViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint * heigthCodigo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint * heigthCodigoRecibido;

@property(nonatomic,weak)IBOutlet UILabel * lblTitulo;

@property(nonatomic,weak)IBOutlet UIButton * btnEnviarCodigo;

@property(nonatomic,weak)IBOutlet UIButton * btnIngresarCodigo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint * topBotonEnviarCodigo;

@end
