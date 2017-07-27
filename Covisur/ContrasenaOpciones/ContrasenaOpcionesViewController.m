//
//  ContrasenaOpcionesViewController.m
//  Covisur
//
//  Created by Christian Fernandez on 7/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "ContrasenaOpcionesViewController.h"
#import "NSMutableAttributedString+Color.h"

@interface ContrasenaOpcionesViewController ()

@end

@implementation ContrasenaOpcionesViewController

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurerView{
    
    [self.btnEnviarCodigo.layer setCornerRadius:15.0];
    [self.btnIngresarCodigo.layer setCornerRadius:15.0];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"Si has olvidado tu contraseña, en pocos minutos, recibirás un correo electrónico con un enlace para restablecer la contraseña."];
    [string setColorForText:@"Si has olvidado tu contraseña" withColor:[UIColor colorWithRed:102.0/255.0 green:168.0/255.0 blue:223.0/255.0 alpha:1]];
    [string setColorForText:@", en pocos minutos, recibirás un correo electrónico con un enlace para restablecer la contraseña." withColor:[UIColor colorWithRed:93.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1]];
    [self.lblTitulo setAttributedText:string];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        self.topBotonEnviarCodigo.constant = 120;
    }else if (([[UIScreen mainScreen] bounds].size.height == 667)) {
        self.topBotonEnviarCodigo.constant = 120;
        self.heigthCodigo.constant = 40;
        self.heigthCodigoRecibido.constant = 40;
        [self.btnEnviarCodigo.layer setCornerRadius:20.0];
        [self.btnIngresarCodigo.layer setCornerRadius:20.0];
    }else if (([[UIScreen mainScreen] bounds].size.height == 736)) {
        self.topBotonEnviarCodigo.constant = 150;
        self.heigthCodigo.constant = 40;
        self.heigthCodigoRecibido.constant = 40;
        [self.btnEnviarCodigo.layer setCornerRadius:20.0];
        [self.btnIngresarCodigo.layer setCornerRadius:20.0];
    }
    [self.view layoutIfNeeded];
}

#pragma mark - IBActions

-(IBAction)volver:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
