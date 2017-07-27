//
//  DatosInvestigadoViewController.h
//  Covisur
//
//  Created by Christian Fernandez on 14/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatosInvestigadoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@property (weak, nonatomic) IBOutlet UITextField *txtTipoIdentificacion;

@property (weak, nonatomic) IBOutlet UITextField *txtNumeroIdentificacion;

@property (weak, nonatomic) IBOutlet UITextField *txtNombresApellidos;

@property (weak, nonatomic) IBOutlet UITextField *txtTelefono;

@property(nonatomic,weak)UIView * tViewSeleccionado;

@property(nonatomic,weak)IBOutlet UIView * vistaNumeroPaso;

@property(nonatomic,weak)UITextField * txtSeleccionado;

@property(nonatomic,strong)NSMutableArray * dataTipoCedula;

@property(nonatomic,strong)NSMutableArray * data;

@property(nonatomic,strong)NSMutableDictionary * dataEnvio;

@property(nonatomic,weak)NSString * tidDocumento;

// Vista Cedula

@property (nonatomic,retain) IBOutlet UIView * vistaTipoCedula;
@property (nonatomic,retain) IBOutlet UIPickerView * pickerTipoCedula;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

@end
