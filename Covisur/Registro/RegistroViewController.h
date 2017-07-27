//
//  RegistroViewController.h
//  Covisur
//
//  Created by Christian Fernandez on 7/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistroViewController : UIViewController<UITabBarControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@property (weak, nonatomic) IBOutlet UITextField *txtNombres;

@property (weak, nonatomic) IBOutlet UITextField *txtApellidos;

@property (weak, nonatomic) IBOutlet UITextField *txtTipoIdentificacion;

@property (weak, nonatomic) IBOutlet UITextField *txtNumeroIdentificacion;

@property (weak, nonatomic) IBOutlet UITextField *txtCorreo;

@property (weak, nonatomic) IBOutlet UITextField *txtCorreoConfirmacion;

@property (weak, nonatomic) IBOutlet UITextField *txtDireccion;

@property (weak, nonatomic) IBOutlet UITextField *txtTelefono;

@property (weak, nonatomic) IBOutlet UITextField *txtContrasena;

@property (weak, nonatomic) IBOutlet UIImageView *imgTerminos;

@property(nonatomic,weak)UIView * tViewSeleccionado;

@property(nonatomic,weak)UITextField * txtSeleccionado;

@property(nonatomic,weak)NSString * tidDocumento;

@property(nonatomic,weak)IBOutlet UIImageView * imgCheck;

@property(nonatomic,strong)NSMutableArray * dataTipoCedula;
@property(nonatomic,strong)NSMutableDictionary * data;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * ladingCheckConstraint;
// Vista Cedula

@property (nonatomic,retain) IBOutlet UIView * vistaTipoCedula;
@property (nonatomic,retain) IBOutlet UIPickerView * pickerTipoCedula;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

@end
