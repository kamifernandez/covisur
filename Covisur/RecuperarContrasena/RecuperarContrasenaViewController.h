//
//  RecuperarContrasenaViewController.h
//  Covisur
//
//  Created by Christian Fernandez on 7/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecuperarContrasenaViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint * topTitulo;

@property (nonatomic,weak) IBOutlet UILabel * lblTitulo;

@property (nonatomic,weak) IBOutlet UIView * viewAlerta;

@property (weak, nonatomic) IBOutlet UITextField *txtUsuario;

@property(nonatomic,strong)NSMutableDictionary * data;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

@end
