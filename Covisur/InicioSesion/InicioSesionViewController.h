//
//  InicioSesionViewController.h
//  Covisur
//
//  Created by Christian Fernandez on 7/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InicioSesionViewController : UIViewController<UITabBarControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint * topIconConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint * topPrimeraCajaConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint * topCajaAbajoCajaConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint * ladingRegistrarse;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@property (weak, nonatomic) IBOutlet UITextField *txtUsuario;

@property (weak, nonatomic) IBOutlet UITextField *txtContrasena;

@property(nonatomic,weak)UIView * tViewSeleccionado;

@property(nonatomic,strong)NSMutableDictionary *data;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

@end
