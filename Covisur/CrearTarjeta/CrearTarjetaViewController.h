//
//  CrearTarjetaViewController.h
//  Covisur
//
//  Created by Christian Fernandez on 7/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CrearTarjetaViewController : UIViewController

@property(nonatomic,strong)NSString * opcionTarjeta;

@property(nonatomic,strong)NSMutableDictionary * datosTarjeta;

@property(nonatomic,weak)IBOutlet UILabel * lblTitulo;

@property(nonatomic,weak)IBOutlet UIScrollView * scroll;

@property(nonatomic,weak)IBOutlet UITextField * txtnombreTarjeta;

@property (weak, nonatomic) IBOutlet UITextField *txtNumeroTarjeta;

@property (weak, nonatomic) IBOutlet UITextField *txtMesExpiracion;

@property (weak, nonatomic) IBOutlet UITextField *txtAnoExpiracion;

@property (weak, nonatomic) IBOutlet UIView *vistaCodigoSeguridad;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint * leadingCheck;

@property (weak, nonatomic) IBOutlet UITextField *txtCodigoSeguridad;

@property (weak, nonatomic) IBOutlet UITextField *txtNombreTitular;

@property (weak, nonatomic) IBOutlet UITextField *txtDocumentoTitular;

@property (weak, nonatomic) IBOutlet UITextField *txtTelefonoTitular;

@property (weak, nonatomic) IBOutlet UITextField *txtCorreoTitular;

@property (weak, nonatomic) IBOutlet UITextField *txtDireccionTitular;

@property (weak, nonatomic) IBOutlet UITextField *txtCiudadTitular;

@property (strong, nonatomic)NSMutableArray *dataPicker;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint * hegitContentScroll;

@property(nonatomic,weak)IBOutlet UIImageView * imgCheck;

@property(nonatomic,weak)UIView * tViewSeleccionado;

@property(nonatomic,weak)UITextField * txtSeleccionado;

@property (weak, nonatomic) IBOutlet UIView *vistaNombreTitular;

@property (weak, nonatomic) IBOutlet UIView *vistaDocumentoTitular;

@property (weak, nonatomic) IBOutlet UIView *vistaTelefonoTitular;

@property (weak, nonatomic) IBOutlet UIView *vistaCorreoTitular;

@property (weak, nonatomic) IBOutlet UIView *vistaDireccionTitular;

@property (weak, nonatomic) IBOutlet UIView *vistaCiudadTitular;

@property(nonatomic,strong)NSMutableArray * data;

@property(nonatomic,strong)NSString * marcaTarjeta;

@property(nonatomic,strong)NSString * crearEditar;

// Vista Cedula

@property (nonatomic,retain) IBOutlet UIView * vistaTipoCedula;
@property (nonatomic,retain) IBOutlet UIPickerView * pickerTipoCedula;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;


@end
