//
//  AgendamientoServiciosViewController.m
//  Covisur
//
//  Created by Christian Fernandez on 8/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "AgendamientoServiciosViewController.h"
#import "MisOrdenesServicioViewController.h"
#import "ResumenServiciosViewController.h"
#import "utilidades.h"
#import "FTWCache.h"
#import "NSString+MD5.h"
#import "RequestUrl.h"

@interface AgendamientoServiciosViewController (){
    int tagBotonCiudad;
    int tagBotonFecha;
    int tagCellSelected;
    int tagAnterior;
    int tagPickerCity;
    UITableViewCell *celdaActiva;
    int diaComienzo;
    int diasParaAgendar;
    int selectedDate;
}

@end

@implementation AgendamientoServiciosViewController

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated
{
    // Notificationes que se usan para cuando se muestra y se esconde el teclado
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mostrarTeclado:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocultarTeclado:) name:UIKeyboardDidHideNotification object:nil];
    [super viewWillAppear:NO];
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
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    tagPickerCity = 0;
    diaComienzo = [[_defaults objectForKey:@"min_day_schedule"] intValue];
    diasParaAgendar = [[_defaults objectForKey:@"max_day_schedule"] intValue];
    [self.lblValorTotal setText:self.dataTotal];
    
    NSMutableArray * temporal = self.data;
    
    int countData = (int)[temporal count];
    
    if (countData > 1) {
        if (self.data) {
            self.data = nil;
            self.data = [[NSMutableArray alloc] init];
        }
        
        self.dataSinFechas = [[NSMutableArray alloc] init];
        
        for (int i = 0; i<countData; i++) {
            NSMutableDictionary * datosServicios = [temporal objectAtIndex:i];
            if ([[NSString stringWithFormat:@"%@",[datosServicios objectForKey:@"field_has_scheduled"]] isEqualToString:@"1"]) {
                [datosServicios setObject:@"NO" forKey:@"fechacompleta"];
                [datosServicios setObject:@"NO" forKey:@"ciudadcompleta"];
                [datosServicios setObject:@"NO" forKey:@"direccioncompleta"];
                [datosServicios setObject:@"" forKey:@"fechaNormal"];
                [datosServicios setObject:@"" forKey:@"fecha"];
                [datosServicios setObject:@"" forKey:@"ciudad"];
                [datosServicios setObject:@"" forKey:@"direccion"];
                [self.data addObject:datosServicios];
            }else{
                [self.dataSinFechas addObject:datosServicios];
            }
        }
    }else{
        if (self.data) {
            self.data = nil;
            self.data = [[NSMutableArray alloc] init];
        }
        NSMutableDictionary * datosServicios = [temporal objectAtIndex:0];
        if ([[NSString stringWithFormat:@"%@",[datosServicios objectForKey:@"field_has_scheduled"]] isEqualToString:@"1"]) {
            [datosServicios setObject:@"NO" forKey:@"fechacompleta"];
            [datosServicios setObject:@"NO" forKey:@"ciudadcompleta"];
            [datosServicios setObject:@"NO" forKey:@"direccioncompleta"];
            [datosServicios setObject:@"" forKey:@"fechaNormal"];
            [datosServicios setObject:@"" forKey:@"fecha"];
            [datosServicios setObject:@"" forKey:@"ciudad"];
            [datosServicios setObject:@"" forKey:@"direccion"];
            [self.data addObject:datosServicios];
        }
    }

    [[NSBundle mainBundle] loadNibNamed:@"HeaderTableViewAgendamiento" owner:self options:nil];
    [self.tblServicios setTableHeaderView:self.vistaHeader];
    int timer = [[_defaults objectForKey:@"time_delete_schedule"] intValue];
    timer = timer*60;
    NSLog(@"%i",timer);
    [self.vistaNumeroPaso.layer setCornerRadius:self.vistaNumeroPaso.frame.size.width/2];
    [self performSelector:@selector(alertaTiempoFinalizado) withObject:nil afterDelay:timer];
}

-(void)alertaTiempoFinalizado{
    NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
    [msgDict setValue:@"Atención" forKey:@"Title"];
    [msgDict setValue:@"Su tiempo de agendamiento ha terminado" forKey:@"Message"];
    [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
    [msgDict setValue:@"" forKey:@"Cancel"];
    [msgDict setValue:@"102" forKey:@"Tag"];
    
    [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                        waitUntilDone:YES];
}

-(void)mostrarVistaPickerCiudades{
    [self.view endEditing:TRUE];
    [[NSBundle mainBundle] loadNibNamed:@"VistaCiudadPicker" owner:self options:nil];
    [self.vistaCiudad setFrame:self.view.frame];
    UITableViewCell *cell = [self.tblServicios cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tagBotonCiudad inSection:0]];
    
    int index = tagBotonCiudad*10;
    
    UITextField * txtCiudad = (UITextField *)[cell viewWithTag:index+3];
    
    NSString * title = [[self.pickerCiudad delegate] pickerView:self.pickerCiudad titleForRow:tagPickerCity forComponent:0];
    
    [txtCiudad setText:title];
    
    NSString * tid = [NSString stringWithFormat:@"%@",[[_dataCiudades objectAtIndex:tagBotonCiudad] objectForKey:@"tid"]];
    
    NSMutableDictionary * dataFecha = [self.data objectAtIndex:tagBotonCiudad];
    [dataFecha setObject:tid forKey:@"ciudad"];
    [dataFecha setObject:@"YES" forKey:@"ciudadcompleta"];
    
    [self.pickerCiudad reloadAllComponents];
    [self.tabBarController.view addSubview:self.vistaCiudad];
}

#pragma mark - Own Methods

-(void)pasarVistaResumen{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ResumenServiciosViewController *resumenServiciosViewController = [story instantiateViewControllerWithIdentifier:@"ResumenServiciosViewController"];
    resumenServiciosViewController.dataServicesConfirmacion = self.tempEnvio;
    resumenServiciosViewController.dataTotal = self.lblValorTotal.text;
    resumenServiciosViewController.paso = @"4";
    [self.navigationController pushViewController:resumenServiciosViewController animated:YES];
}

-(NSMutableArray *)obtenerArrayAgenda{
    NSMutableArray * tempReturn = [[NSMutableArray alloc] init];
    for (int i = 0; i<[self.tempEnvio count]; i++) {
        NSMutableDictionary * temp = [[NSMutableDictionary alloc] init];
        [temp setObject:[[self.tempEnvio objectAtIndex:i] objectForKey:@"tid"] forKey:@"service_id"];
        if ([[[self.tempEnvio objectAtIndex:i] objectForKey:@"fechacompleta"] isEqualToString:@"YES"]) {
            NSString * fecha = [[self.tempEnvio objectAtIndex:i] objectForKey:@"fecha"];
            [temp setObject:fecha forKey:@"date"];
        }
        
        if ([[[self.tempEnvio objectAtIndex:i] objectForKey:@"direccioncompleta"] isEqualToString:@"YES"]) {
            NSString * direccion = [[self.tempEnvio objectAtIndex:i] objectForKey:@"direccion"];
            [temp setObject:direccion forKey:@"address"];
        }
        
        if ([[[self.tempEnvio objectAtIndex:i] objectForKey:@"ciudadcompleta"] isEqualToString:@"YES"]) {
            NSString * ciudad = [[self.tempEnvio objectAtIndex:i] objectForKey:@"ciudad"];
            [temp setObject:ciudad forKey:@"city"];
        }
        
        [tempReturn addObject:temp];
        
    }
    return tempReturn;
}

#pragma mark - IBActions

-(void)btnPickerCiudad:(id)sender{
    tagBotonCiudad = (int)[sender tag];
    if ([_dataCiudades count]>0) {
        [self mostrarVistaPickerCiudades];
    }else{
        [self requestServerCiudades];
    }
}

-(void)btnPickerFecha:(id)sender{
    tagBotonFecha = (int)[sender tag];
    [self.view endEditing:TRUE];
    [[NSBundle mainBundle] loadNibNamed:@"VistaFechaPicker" owner:self options:nil];
    //[self.lblFecha setText:[utilidades convertDayName:[self.datePicker date]]];
    [self.vistaDatePikcer setFrame:self.view.frame];
    self.dataFechas = [utilidades getDatesFromNumber:diaComienzo numberOfDays:diasParaAgendar];
    //[self.view addSubview:self.vistaDatePikcer];
    [self.lblFecha setText:[utilidades convertDayName:[self.dataFechas objectAtIndex:0]]];
    
    int index = tagBotonFecha*10;
    
    UITableViewCell *cell = [self.tblServicios cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tagBotonFecha inSection:0]];
    
    UITextField * txtCiudad = (UITextField *)[cell viewWithTag:index+2];
    
    [txtCiudad setText:[utilidades convertDayName:[self.dataFechas objectAtIndex:0]]];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-YYYY"];
    NSString *dateString = [dateFormat stringFromDate:[self.dataFechas objectAtIndex:0]];
    
    self.dateFormatterFechasEnvio = dateString;
    
    NSMutableDictionary * dataFecha = [self.data objectAtIndex:tagBotonFecha];
    [dataFecha setObject:[utilidades convertDayName:[self.dataFechas objectAtIndex:0]] forKey:@"fechaNormal"];
    
    [self.pickerDates reloadAllComponents];
    [self.tabBarController.view addSubview:self.vistaDatePikcer];
}

- (IBAction)datePickerValueChanged:(id)sender{
    UIDatePicker *picker = (UIDatePicker *)sender;
    NSString *dateString;
    
    dateString = [NSDateFormatter localizedStringFromDate:[picker date]
                                                dateStyle:NSDateFormatterMediumStyle
                                                timeStyle:NSDateFormatterNoStyle];
    
    [self.lblFecha setText:[utilidades convertDayName:[self.datePicker date]]];
}

-(IBAction)btnAgendar:(id)sender{
    
    NSMutableDictionary * dataFecha = [self.data objectAtIndex:tagBotonFecha];
    [dataFecha setObject:self.dateFormatterFechasEnvio forKey:@"fecha"];
    [dataFecha setObject:@"YES" forKey:@"fechacompleta"];
    
    [self.vistaDatePikcer removeFromSuperview];
    self.vistaDatePikcer = nil;
}

-(IBAction)btnSeleccionarCiudad:(id)sender{
    [self.vistaCiudad removeFromSuperview];
    self.vistaCiudad = nil;
}

-(IBAction)btnSiguiente:(id)sender{
    [self.view endEditing:TRUE];
    int countData = (int)[self.data count];
    for (int i = 0; i<countData; i++) {
        NSMutableDictionary * dataServicios = [self.data objectAtIndex:i];
        if ([[dataServicios objectForKey:@"fechacompleta"] isEqualToString:@"NO"] || [[dataServicios objectForKey:@"ciudadcompleta"] isEqualToString:@"NO"] || [[dataServicios objectForKey:@"direccioncompleta"] isEqualToString:@"NO"]) {
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"Para poder continuar por favor seleccione todos los datos para su agendamiento" forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"" forKey:@"Cancel"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
            break;
        }else{
            NSString * compararFecha = [dataServicios objectForKey:@"fecha"];
            if (i != countData) {
                for (int j = i; j<countData; j++) {
                    if (i != j) {
                        NSMutableDictionary * dataServiciosDos = [self.data objectAtIndex:j];
                        if ([compararFecha isEqualToString:[dataServiciosDos objectForKey:@"fecha"]]) {
                            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
                            [msgDict setValue:@"Atención" forKey:@"Title"];
                            [msgDict setValue:@"Para poder continuar por favor verifique que las fechas de los servicios no coincidan" forKey:@"Message"];
                            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
                            [msgDict setValue:@"" forKey:@"Cancel"];
                            
                            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                                waitUntilDone:YES];
                            break;
                        }
                    }
                }
            }
        }
    }
    
    self.tempEnvio = [[NSMutableArray alloc] initWithArray:self.data];
    [self.tempEnvio addObjectsFromArray:self.dataSinFechas];
    
    [self requestServerAgendamiento];
}

-(IBAction)btnAtras:(id)sender{
    NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
    [msgDict setValue:@"Atención" forKey:@"Title"];
    [msgDict setValue:@"¿Seguro que quieres volver atrás, si ya asignaste alguna fecha pueda que la pierdas al volver?" forKey:@"Message"];
    [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
    [msgDict setValue:@"Cancelar" forKey:@"Cancel"];
    [msgDict setValue:@"101" forKey:@"Tag"];
    
    [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                        waitUntilDone:YES];
}

#pragma mark - UITableView Delegate & Datasrouce

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *CellIdentifier = @"AgendamientoTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"AgendamientoTableViewCell" owner:self options:nil];
        cell = _celdaTabla;
        self.celdaTabla = nil;
    }
    
    [self.lblServicio setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"name"]];
    
    int indexPathRow = (int)indexPath.row;
    int index = indexPathRow*10;
    
    UIImageView * imgCategoria = [cell viewWithTag:1];
    
    NSString * urlEnvio = [[self.data objectAtIndex:0]objectForKey:@"field_image"];
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
    
    UITextField * txtFecha = (UITextField *)[cell viewWithTag:2];
    [txtFecha setTag:index + 2];
    
    if ([[_data objectAtIndex:indexPath.row] objectForKey:@"fecha"]) {
        [txtFecha setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"fechaNormal"]];
    }
    
    UITextField * txtCiudad = (UITextField *)[cell viewWithTag:3];
    [txtCiudad setTag:index + 3];
    if ([[_data objectAtIndex:indexPath.row] objectForKey:@"ciudad"]) {
        [txtCiudad setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"ciudad"]];
    }
    
    [self.btnFecha addTarget:self action:@selector(btnPickerFecha:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnFecha setTag:indexPath.row];
    
    
    [self.btnCiudad addTarget:self action:@selector(btnPickerCiudad:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCiudad setTag:indexPath.row];
    
    UITextField * txtDireccion = (UITextField *)[cell viewWithTag:4];
    [txtDireccion setTag:index + 4];
    
    if ([[_data objectAtIndex:indexPath.row] objectForKey:@"direccion"]) {
        [txtDireccion setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"direccion"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 191;
}

#pragma mark UiPicker Delegates

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// Total rows in our component.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int countData = (int)[self.dataFechas count];
    if (pickerView.tag == 2) {
        countData = (int)[_dataCiudades count];
    }
    return countData;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = [utilidades convertDayName:[self.dataFechas objectAtIndex:row]];
    if (pickerView.tag == 2) {
        title = [[_dataCiudades objectAtIndex:row] objectForKey:@"name"];
    }
    return title;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *title = @"";
    if (pickerView.tag == 2) {
        tagPickerCity = (int)row;
        title=[[_dataCiudades objectAtIndex:row] objectForKey:@"name"];
        
        int index = tagBotonCiudad*10;
        
        UITableViewCell *cell = [self.tblServicios cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tagBotonCiudad inSection:0]];
        
        UITextField * txtCiudad = (UITextField *)[cell viewWithTag:index+3];
        
        [txtCiudad setText:title];
        
        NSString * tid = [NSString stringWithFormat:@"%@",[[_dataCiudades objectAtIndex:row] objectForKey:@"tid"]];
        
        NSMutableDictionary * dataFecha = [self.data objectAtIndex:row];
        [dataFecha setObject:tid forKey:@"ciudad"];
        [dataFecha setObject:@"YES" forKey:@"ciudadcompleta"];
    }else{
        selectedDate = (int)row;
        title = [utilidades convertDayName:[self.dataFechas objectAtIndex:row]];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd-MM-YYYY"];
        NSString *dateString = [dateFormat stringFromDate:[self.dataFechas objectAtIndex:row]];
        
        self.dateFormatterFechasEnvio = dateString;
        
        NSMutableDictionary * dataFecha = [self.data objectAtIndex:tagBotonFecha];
        [dataFecha setObject:title forKey:@"fechaNormal"];
        
        int index = tagBotonFecha*10;
        
        UITableViewCell *cell = [self.tblServicios cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tagBotonFecha inSection:0]];
        
        UITextField * txtCiudad = (UITextField *)[cell viewWithTag:index+2];
        
        [txtCiudad setText:title];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

#pragma mark Metodos TextField

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([_txtSelected.text isEqualToString:@""]) {
        _txtSelected.text = @"0";
    }
    if ([textField.text isEqualToString:@"0"]) {
        textField.text = @"";
    }
    
    float origenTagTemp = (float)[textField tag]/10;
    int origenIndex = truncf(origenTagTemp);
    
    UITableViewCell *cell = [self.tblServicios cellForRowAtIndexPath:[NSIndexPath indexPathForRow:origenIndex inSection:0]];
    celdaActiva = cell;
    tagCellSelected = origenIndex;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    float origenTagTemp = (float)[textField tag]/10;
    int origenIndex = truncf(origenTagTemp);
    NSMutableDictionary * datosServicios = [self.data objectAtIndex:origenIndex];
    if ([textField.text isEqualToString:@""]) {
        [datosServicios setObject:@"NO" forKey:@"direccioncompleta"];
    }else{
        [datosServicios setObject:@"YES" forKey:@"direccioncompleta"];
        [datosServicios setObject:textField.text forKey:@"direccion"];
    }
    [self.view endEditing:TRUE];
    return true;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    float origenTagTemp = (float)[textField tag]/10;
    int origenIndex = truncf(origenTagTemp);
    NSMutableDictionary * datosServicios = [self.data objectAtIndex:origenIndex];
    if ([textField.text isEqualToString:@""]) {
        [datosServicios setObject:@"NO" forKey:@"direccioncompleta"];
    }else{
        [datosServicios setObject:@"YES" forKey:@"direccioncompleta"];
        [datosServicios setObject:textField.text forKey:@"direccion"];
    }
    [self.view endEditing:TRUE];
}

#pragma mark Metodos Teclado

-(void)mostrarTeclado:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.width-60, 0.0);
    _tblServicios.contentInset = contentInsets;
    _tblServicios.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = _tblServicios.frame;
    aRect.size.height -= kbSize.width;
    if (!CGRectContainsPoint(aRect, celdaActiva.frame.origin) ) {
        // El 160 es un parametro que depende de la vista en la que se encuentra, se debe ajustar dependiendo del caso
        float tamano = 0.0;
        
        float version=[[UIDevice currentDevice].systemVersion floatValue];
        if(version <7.0){
            tamano = celdaActiva.frame.origin.y-100;
        }else{
            tamano = celdaActiva.frame.origin.y-100;
        }
        if(tamano<0)
            tamano=0;
        CGPoint scrollPoint = CGPointMake(0.0, tamano);
        if (tagCellSelected != tagAnterior) {
            [_tblServicios setContentOffset:scrollPoint animated:YES];
        }
        tagAnterior = tagCellSelected;
    }
}

-(void)ocultarTeclado:(NSNotification*)aNotification
{
    [ UIView animateWithDuration:0.4f animations:^
     {
         UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
         _tblServicios.contentInset = contentInsets;
         _tblServicios.scrollIndicatorInsets = contentInsets;
     }completion:^(BOOL finished){
         
     }];
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
                                        if ([[msgDict objectForKey:@"Tag"] isEqualToString:@"101"]) {
                                            self.data = nil;
                                            [self envioServerBorrarReserva];
                                            [self.navigationController popViewControllerAnimated:YES];
                                        }
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
                                        if ([[msgDict objectForKey:@"Tag"] isEqualToString:@"102"]) {
                                            for (UIViewController *controller in self.navigationController.viewControllers) {
                                                
                                                [[NSRunLoop currentRunLoop] cancelPerformSelector:@selector(alertaTiempoFinalizado)
                                                                                           target:self
                                                                                         argument:nil];
                                                
                                                [self requestServerBorrarReserva];
                                                //Do not forget to import AnOldViewController.h
                                                if ([controller isKindOfClass:[MisOrdenesServicioViewController class]]) {
                                                    
                                                    [self.navigationController popToViewController:controller
                                                                                          animated:YES];
                                                    break;
                                                }
                                            }
                                        }
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

#pragma mark - WebServices
#pragma mark - Borrar Reserva

-(void)requestServerBorrarReserva{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerBorrarReserva) object:nil];
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

-(void)envioServerBorrarReserva{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * dataServices = [RequestUrl borrarReserva:[_defaults objectForKey:@"idServicio"]];
    [self performSelectorOnMainThread:@selector(ocultarCargandoBorrarReserva:) withObject:dataServices waitUntilDone:YES];
}

-(void)ocultarCargandoBorrarReserva:(NSMutableDictionary *)documentosTemporal{
    if ([documentosTemporal count]>0) {
        NSLog(@"Reserva Borrada");
    }else{
        [self requestServerBorrarReserva];
    }
}

#pragma mark - Borrar Reserva

-(void)requestServerAgendamiento{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerAgendamiento) object:nil];
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

-(void)envioServerAgendamiento{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * dataEnvio = [[NSMutableDictionary alloc] init];
    [dataEnvio setObject:@"service_orders" forKey:@"type"];
    [dataEnvio setObject:[_defaults objectForKey:@"uid"] forKey:@"uid"]; //Poner para produccion
    //[dataEnvio setObject:@"85" forKey:@"uid"]; //Poner para desarrollo
    
    [dataEnvio setObject:[self obtenerArrayAgenda] forKey:@"payment_services"];
    
    NSMutableDictionary * dataServices = [RequestUrl reservar:dataEnvio];
    [self performSelectorOnMainThread:@selector(ocultarCargandoAgendamiento:) withObject:dataServices waitUntilDone:YES];
}

-(void)ocultarCargandoAgendamiento:(NSMutableDictionary *)dataServices{
    if ([dataServices count]==0) {
        [self pasarVistaResumen];
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

#pragma mark - Obtener Ciudades

-(void)requestServerCiudades{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerCiudades) object:nil];
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

-(void)envioServerCiudades{
    NSMutableDictionary * documentosTemporal = [RequestUrl obtenerCiudades];
    [self performSelectorOnMainThread:@selector(ocultarCargandoCiudades:) withObject:documentosTemporal waitUntilDone:YES];
}

-(void)ocultarCargandoCiudades:(NSMutableDictionary *)documentosTemporal{
    if ([documentosTemporal count]>0) {
        _dataCiudades = [[documentosTemporal objectForKey:@"list"] copy];
        [self mostrarVistaPickerCiudades];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Su usuario o contraseñan son incorrectos" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
    [self mostrarCargando];
}

@end
