//
//  SeleccionServiciosViewController.m
//  Covisur
//
//  Created by Christian Fernandez on 14/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "SeleccionServiciosViewController.h"
#import "AgendamientoServiciosViewController.h"
#import "ResumenServiciosViewController.h"
#import "utilidades.h"
#import "FTWCache.h"
#import "NSString+MD5.h"
#import "RequestUrl.h"

@interface SeleccionServiciosViewController (){
    int totalServicios;
}

@end

@implementation SeleccionServiciosViewController

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configurerView{
    self.serviciosSeleccionados = [[NSMutableArray alloc] init];
    [[NSBundle mainBundle] loadNibNamed:@"VistaSeleccionServicioEncabezado" owner:self options:nil];
    [self.tblSeleccionServicios setTableHeaderView:self.vistaHeader];
    [self.vistaNumeroPaso.layer setCornerRadius:self.vistaNumeroPaso.frame.size.width/2];
    [self requestServerServiciosPagos];
}

#pragma mark - IBActions

-(IBAction)btnSiguiente:(id)sender{
    if (self.serviciosSeleccionados) {
        self.serviciosSeleccionados = nil;
        self.serviciosSeleccionados = [[NSMutableArray alloc] init];
    }
    if (totalServicios == 0) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Para poder continuar por favor seleccione uno de nuestros servicios" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
        bool tieneAgenda = NO;
        int countArray = (int)[self.dataServices count];
        for (int i = 0; i < countArray; i++) {
            NSMutableDictionary * datosServicios = [self.dataServices objectAtIndex:i];
            if ([[datosServicios objectForKey:@"check"] isEqualToString:@"YES"]) {
                [self.serviciosSeleccionados addObject:datosServicios];
                if ([[NSString stringWithFormat:@"%@",[datosServicios objectForKey:@"field_has_scheduled"]] isEqualToString:@"1"]) {
                    tieneAgenda = YES;
                }
            }
        }
        if (tieneAgenda) {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            AgendamientoServiciosViewController *agendamientoServiciosViewController = [story instantiateViewControllerWithIdentifier:@"AgendamientoServiciosViewController"];
            agendamientoServiciosViewController.data = self.serviciosSeleccionados;
            agendamientoServiciosViewController.dataTotal = self.lblValorTotal.text;
            [self.navigationController pushViewController:agendamientoServiciosViewController animated:YES];
        }else{
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ResumenServiciosViewController *resumenServiciosViewController = [story instantiateViewControllerWithIdentifier:@"ResumenServiciosViewController"];
            resumenServiciosViewController.dataServicesConfirmacion = self.serviciosSeleccionados;
            resumenServiciosViewController.dataTotal = self.lblValorTotal.text;
            resumenServiciosViewController.paso = @"3";
            [self.navigationController pushViewController:resumenServiciosViewController animated:YES];
        }
    }
}

-(IBAction)volver:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView Delegate & Datasrouce

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataServices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *CellIdentifier = @"";
    
    
    CellIdentifier = @"SeleccionServiciosTableViewCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"SeleccionServiciosTableViewCell" owner:self options:nil];
        cell = _celdaTabla;
        self.celdaTabla = nil;
    }
    
    
    [self.lblService setText:[[_dataServices objectAtIndex:indexPath.row] objectForKey:@"name"]];
    NSString * texto = [[_dataServices objectAtIndex:indexPath.row] objectForKey:@"description"];
    
    UIFont *font = [UIFont systemFontOfSize: 14];
    NSAttributedString *tes = [utilidades
                               attributedHTMLString: texto
                               useFont: font
                               useHexColor: @"rgb(93,93,93)"];
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString: tes];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing: 6];
    [style setAlignment: NSTextAlignmentJustified];
    
    [mutableAttributedString addAttribute: NSParagraphStyleAttributeName
                                    value: style
                                    range: NSMakeRange(0, mutableAttributedString.mutableString.length)];
    
    //
    self.lblDescription.attributedText = mutableAttributedString;
    
    int total = [[[_dataServices objectAtIndex:indexPath.row] objectForKey:@"field_price"] intValue];
    
    [self.lblValor setText:[NSString stringWithFormat:@"Valor $%@",[utilidades decimalNumberFormat:total]]];
    
    if ([[_dataServices objectAtIndex:indexPath.row] objectForKey:@"check"]) {
        if ([[[_dataServices objectAtIndex:indexPath.row] objectForKey:@"check"] isEqualToString:@"YES"]) {
            [self.imgCheckService setHidden:FALSE];
            [cell setBackgroundColor:[UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0]];
        }else{
            [cell setBackgroundColor:[UIColor whiteColor]];
            [self.imgCheckService setHidden:TRUE];
        }
    }
    
    UIImageView * imgCategoria = [cell viewWithTag:1];
    
    NSString * urlEnvio = [[self.dataServices objectAtIndex:indexPath.row]objectForKey:@"field_image"];
    if ([urlEnvio isEqualToString:@""]) {
        [imgCategoria setFrame:CGRectMake(imgCategoria.frame.origin.x, imgCategoria.frame.origin.y - 15, imgCategoria.frame.size.width, imgCategoria.frame.size.height)];
    }else{
        NSURL *imageURL = [NSURL URLWithString:urlEnvio];
        NSString *key = [urlEnvio MD5Hash];
        NSData *data = [FTWCache objectForKey:key];
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            //UIImage *image = [UIImage imageNamed:@"imagen-detalle@3x.png"];
            imgCategoria.image = image;
        } else {
            //imagen.image = [UIImage imageNamed:@"img_def"];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                NSData *data = [NSData dataWithContentsOfURL:imageURL];
                [FTWCache setObject:data forKey:key];
                UIImage *image = [UIImage imageWithData:data];
                //UIImage *image = [UIImage imageNamed:@"imagen-detalle@3x.png"];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    imgCategoria.image = image;
                });
            });
        }
    }
    
    imgCategoria.contentMode = UIViewContentModeScaleAspectFill;
    
    [imgCategoria.layer setCornerRadius:imgCategoria.frame.size.height/2];
    [imgCategoria.layer setMasksToBounds:YES];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger contadorServicios = [self.serviciosSeleccionados count];
    int total = [[[_dataServices objectAtIndex:indexPath.row] objectForKey:@"field_price"] intValue];
    if (contadorServicios == 0) {
        NSMutableDictionary * temp = [self.dataServices objectAtIndex:indexPath.row];
        [temp setObject:@"YES" forKey:@"check"];
        [self.serviciosSeleccionados addObject:temp];
        totalServicios += total;
        [self.lblValorTotal setText:[NSString stringWithFormat:@"Valor Total $%@",[utilidades decimalNumberFormat:totalServicios]]];
    }else{
        if ([[[_dataServices objectAtIndex:indexPath.row] objectForKey:@"check"] isEqualToString:@"YES"]) {
            NSMutableDictionary * temp = [self.dataServices objectAtIndex:indexPath.row];
            [temp setObject:@"NO" forKey:@"check"];
            totalServicios = totalServicios - total ;
            [self.lblValorTotal setText:[NSString stringWithFormat:@"Valor Total $%@",[utilidades decimalNumberFormat:totalServicios]]];
        }else{
            NSMutableDictionary * temp = [self.dataServices objectAtIndex:indexPath.row];
            [temp setObject:@"YES" forKey:@"check"];
            totalServicios += total;
            [self.lblValorTotal setText:[NSString stringWithFormat:@"Valor Total $%@",[utilidades decimalNumberFormat:totalServicios]]];
        }
    }
    
    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    [self.tblSeleccionServicios reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

#pragma mark - showAlert metodo

-(void)showAlert:(NSMutableDictionary *)msgDict
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:[msgDict objectForKey:@"Title"]
                                 message:[msgDict objectForKey:@"Message"]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    if ([[msgDict objectForKey:@"Cancel"] length]>0) {
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:[msgDict objectForKey:@"Aceptar"]
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:[msgDict objectForKey:@"Cancel"]
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       
                                   }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
    }else{
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:[msgDict objectForKey:@"Aceptar"]
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                    }];
        
        [alert addAction:yesButton];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Metodos Vista Cargando

-(void)mostrarCargando{
    @autoreleasepool {
        if (_vistaWait.hidden == TRUE) {
            _vistaWait.hidden = FALSE;
            CALayer * l = [_vistaWait layer];
            [l setMasksToBounds:YES];
            [l setCornerRadius:10.0];
            // You can even add a border
            [l setBorderWidth:1.5];
            [l setBorderColor:[[UIColor whiteColor] CGColor]];
            
            [_indicador startAnimating];
        }else{
            _vistaWait.hidden = TRUE;
            [_indicador stopAnimating];
        }
    }
}

#pragma mark - Obtener Servicios de Pago

-(void)requestServerServiciosPagos{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerServiciosPagos) object:nil];
        [queue1 addOperation:operation];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene conexión a internet" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        [msgDict setValue:@"101" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
}

-(void)envioServerServiciosPagos{
    NSMutableDictionary * dataServices = [RequestUrl serviciosPagos];
    [self performSelectorOnMainThread:@selector(ocultarCargandoServiciosPagos:) withObject:dataServices waitUntilDone:YES];
}

-(void)ocultarCargandoServiciosPagos:(NSMutableDictionary *)documentosTemporal{
    if ([documentosTemporal count]>0) {
        _dataServices = [[documentosTemporal objectForKey:@"list"] copy];
        [self.tblSeleccionServicios reloadData];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Algo sucedio por favor intenta de nuevo" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
    [self mostrarCargando];
}

@end
