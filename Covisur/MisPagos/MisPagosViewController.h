//
//  MisPagosViewController.h
//  Covisur
//
//  Created by Christian Fernandez on 21/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface MisPagosViewController : UIViewController <MFMailComposeViewControllerDelegate,NSURLSessionDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblMisServicios;
@property (nonatomic,retain) IBOutlet UITableViewCell * celdaTabla;

@property(nonatomic,strong)NSMutableArray * data;

// Cell Servicios

@property (weak, nonatomic) IBOutlet UILabel *lblService;

@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@property (weak, nonatomic) IBOutlet UILabel *lblValor;

@property(nonatomic,weak)IBOutlet UILabel * lblFecha;

@property (weak, nonatomic) IBOutlet UIView *vistaTotal;

@property (weak, nonatomic) IBOutlet UIButton *btnDescargar;

@property (weak, nonatomic) IBOutlet UIButton *btnVolver;

@property (weak, nonatomic)NSString *ventana;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;

@end
