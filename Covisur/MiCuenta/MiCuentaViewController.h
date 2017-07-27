//
//  MiCuentaViewController.h
//  Covisur
//
//  Created by Christian Fernandez on 7/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiCuentaViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@property (weak, nonatomic) IBOutlet UITextField *txtNombres;

@property (weak, nonatomic) IBOutlet UITextField *txtApellidos;

@property (weak, nonatomic) IBOutlet UITextField *txtTipoIdentificacion;

@property (weak, nonatomic) IBOutlet UITextField *txtNumeroIdentificacion;

@property (weak, nonatomic) IBOutlet UITextField *txtCorreo;

@property (weak, nonatomic) IBOutlet UITextField *txtDireccion;

@property (weak, nonatomic) IBOutlet UITextField *txtTelefono;

@property (weak, nonatomic) IBOutlet UITextField *txtContrasena;

@property (weak, nonatomic) IBOutlet UITextField *txtRepetirContrasena;


@property (weak, nonatomic) IBOutlet UIButton *btnEliminarCuenta;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint * heigthEliminarCuenta;

@property(nonatomic,weak)UIView * tViewSeleccionado;

@property(nonatomic,weak)UITextField * txtSeleccionado;

@property(nonatomic,strong)NSMutableArray * dataTipoCedula;

@property(nonatomic,strong)NSString * idTipoDocumento;

@property(nonatomic,strong)NSMutableDictionary * dataUsuario;

@property(nonatomic,strong)NSMutableDictionary * data;


// Vista Cedula

@property (nonatomic,retain) IBOutlet UIView * vistaTipoCedula;
@property (nonatomic,retain) IBOutlet UIPickerView * pickerTipoCedula;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

@end
