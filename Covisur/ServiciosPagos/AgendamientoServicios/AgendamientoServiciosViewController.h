//
//  AgendamientoServiciosViewController.h
//  Covisur
//
//  Created by Christian Fernandez on 8/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgendamientoServiciosViewController : UIViewController

@property(nonatomic,weak)IBOutlet UITableView * tblServicios;
@property (nonatomic,retain) IBOutlet UITableViewCell * celdaTabla;

@property (weak, nonatomic) IBOutlet UIView *vistaHeader;

@property(nonatomic,strong)NSString * dataTotal;
@property(nonatomic,strong)NSMutableArray * data;
@property(nonatomic,strong)NSMutableArray * dataCiudades;
@property(nonatomic,strong)NSMutableArray * dataFechas;
@property(nonatomic,strong)NSMutableArray * dataSinFechas;

@property(nonatomic,strong)NSString * dateFormatterFechasEnvio;

@property(nonatomic,strong)IBOutlet UILabel * lblValorTotal;

@property(nonatomic,weak)UITextField * txtSelected;

//Tableview Cell

@property (nonatomic,retain) IBOutlet UILabel * lblServicio;
@property (nonatomic,retain) IBOutlet UITextField * lblDireccion;
@property (nonatomic,retain) IBOutlet UIButton * btnFecha;
@property (nonatomic,retain) IBOutlet UIButton * btnCiudad;
@property (nonatomic,retain) IBOutlet UIView * vistaLinea;
@property(nonatomic,weak)IBOutlet UIView * vistaNumeroPaso;

//

@property(nonatomic,strong)NSMutableArray * tempEnvio;

//DatePikcer

@property (nonatomic,retain) IBOutlet UIView * vistaDatePikcer;
@property (nonatomic,retain) IBOutlet UILabel * lblFecha;
@property (nonatomic,retain) IBOutlet UIDatePicker * datePicker;
@property (nonatomic,retain) IBOutlet UIPickerView * pickerDates;

//VistaCiudad

@property (nonatomic,retain) IBOutlet UIView * vistaCiudad;
@property (nonatomic,retain) IBOutlet UIPickerView * pickerCiudad;

// Indicador

@property(nonatomic,weak)IBOutlet UIView *vistaWait;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *indicador;


@end
