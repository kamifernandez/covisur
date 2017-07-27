//
//  MisTarjetasViewController.h
//  Covisur
//
//  Created by Christian Fernandez on 7/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MisTarjetasViewController : UIViewController

@property(nonatomic,weak)IBOutlet UITableView * tblMisTarjetas;
@property (nonatomic,retain) IBOutlet UITableViewCell * celdaTabla;

@property(nonatomic,strong)NSMutableArray * data;

//Tableview Cell

@property (nonatomic,retain) IBOutlet UILabel * lblTarjetaCredito;
@property (nonatomic,retain) IBOutlet UILabel * lblNombre;
@property (nonatomic,retain) IBOutlet UILabel * lblFecha;
@property (nonatomic,retain) IBOutlet UIView * vistaLinea;

//Footer

@property (nonatomic,retain) IBOutlet UIView * misTarjetasFooterCell;
@property (nonatomic,retain) IBOutlet UIView * vistaBotonAgregar;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

@end
