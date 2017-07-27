//
//  ServicioGratuitosViewController.h
//  Covisur
//
//  Created by Christian Fernandez on 7/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServicioGratuitosViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tblSeleccionServicios;
@property (nonatomic,retain) IBOutlet UITableViewCell * celdaTabla;

@property(nonatomic,strong)NSMutableArray * dataServices;

@property(nonatomic,strong)NSMutableArray * serviciosSeleccionados;

// Cell Servicios

@property (weak, nonatomic) IBOutlet UILabel *lblService;

@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@property (weak, nonatomic) IBOutlet UIImageView *imgIconService;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheckService;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

@end
