//
//  PagoServiciosViewController.h
//  Covisur
//
//  Created by Christian Fernandez on 17/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagoServiciosViewController : UIViewController

@property(nonatomic,strong)NSString * valor;

@property(nonatomic,weak)IBOutlet UILabel * lblPaso;

@property(nonatomic,weak)IBOutlet UILabel * lblValorTotal;

@property(nonatomic,weak)IBOutlet UILabel * txtTarjetaCredito;

@property(nonatomic,weak)IBOutlet UIButton * btnPagar;

@property(nonatomic,strong)NSMutableArray * datatarjetas;

@property(nonatomic,strong)NSString * paso;

@property(nonatomic,strong)NSString * nidTarjeta;

// Vista Cedula

@property (nonatomic,weak) IBOutlet UIView * vistaTarjeta;
@property (nonatomic,weak) IBOutlet UIPickerView * pickerTarjeta;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint * leadingVistaPaso;

@property(nonatomic,weak)IBOutlet UIView * vistaNumeroPaso;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

@end
