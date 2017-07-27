//
//  ResumenServiciosViewController.h
//  Covisur
//
//  Created by Christian Fernandez on 16/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResumenServiciosViewController : UIViewController

@property(nonatomic,strong)NSMutableArray * dataServicesConfirmacion;

@property (nonatomic,weak) IBOutlet UITableView * tablaConfirmarServicios;
@property (nonatomic,weak) IBOutlet UITableViewCell * celdaTabla;

@property(nonatomic,weak)IBOutlet UILabel * lblValorTotal;

@property(nonatomic,weak)IBOutlet UILabel * lblPaso;

@property(nonatomic,strong)NSString * dataTotal;

@property(nonatomic,strong)NSString * paso;

@property(nonatomic,weak)IBOutlet UIView * vistaNumeroPaso;

// Cell Servicios

@property (weak, nonatomic) IBOutlet UILabel *lblService;

@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@property (weak, nonatomic) IBOutlet UILabel *lblFecha;

// Header

@property (weak, nonatomic) IBOutlet UIView *headerTabla;

@property (weak, nonatomic) IBOutlet UILabel *lblTipoDocumento;

@property (weak, nonatomic) IBOutlet UILabel *lblNumeroDocumento;

@property (weak, nonatomic) IBOutlet UILabel *lblNombres;

@property (weak, nonatomic) IBOutlet UILabel *lblTelefono;

@end
