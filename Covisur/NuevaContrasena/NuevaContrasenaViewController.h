//
//  NuevaContrasenaViewController.h
//  Covisur
//
//  Created by Christian Fernandez on 7/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NuevaContrasenaViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtNuevaContrasena;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmarContrasena;

@property(nonatomic,strong)NSMutableDictionary * data;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

@end
