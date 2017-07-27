//
//  SeleccionServiciosViewController.h
//  Covisur
//
//  Created by Christian Fernandez on 14/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeleccionServiciosViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *vistaHeader;
@property (weak, nonatomic) IBOutlet UITableView *tblSeleccionServicios;
@property (nonatomic,retain) IBOutlet UITableViewCell * celdaTabla;
@property (weak, nonatomic) IBOutlet UILabel *lblValorTotal;

@property(nonatomic,weak)IBOutlet UIView * vistaNumeroPaso;

@property(nonatomic,strong)NSMutableArray * dataServices;

@property(nonatomic,strong)NSMutableArray * serviciosSeleccionados;

@property(nonatomic,strong)NSMutableDictionary * dataInvestigado;

// Cell Servicios

@property (weak, nonatomic) IBOutlet UILabel *lblService;

@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@property (weak, nonatomic) IBOutlet UILabel *lblValor;

@property (weak, nonatomic) IBOutlet UIImageView *imgIconService;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheckService;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;


@end
