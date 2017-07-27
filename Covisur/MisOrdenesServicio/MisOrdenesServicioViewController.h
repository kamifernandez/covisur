//
//  MisOrdenesServicioViewController.h
//  Covisur
//
//  Created by Christian Fernandez on 10/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MisOrdenesServicioViewController : UIViewController 

@property(nonatomic,weak)IBOutlet UITableView * tblMisServicios;

@property(nonatomic,weak)IBOutlet UITableViewCell * celdaTabla;

@property(nonatomic,weak)IBOutlet UILabel * lblSinDatos;

@property(nonatomic,strong)NSMutableArray * data;

/// Vista Menu

@property(nonatomic,weak)IBOutlet UIView * vistaMenu;

@property(nonatomic,weak)IBOutlet UIView * vistaContentMenu;

// Cell Activos

@property(nonatomic,weak)IBOutlet UILabel * lblNumeroOrden;

@property(nonatomic,weak)IBOutlet UILabel * lblFecha;

@property (weak, nonatomic) IBOutlet UILabel *lblNumeroDocumento;

@property (weak, nonatomic) IBOutlet UILabel *lblServiciosAdquiridos;

@property (weak, nonatomic) IBOutlet UILabel *lblValorTotal;

@property (weak, nonatomic) IBOutlet UIView *vistaTotal;

// Cell Finalizados

@property (weak, nonatomic) IBOutlet UIView *vistaRiesgo;

@property (weak, nonatomic) IBOutlet UILabel *lblNivelRiesgo;

@property(nonatomic,strong)NSMutableArray * dataTipoCedula;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;


@end
