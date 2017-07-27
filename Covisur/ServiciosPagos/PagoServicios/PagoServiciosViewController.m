//
//  PagoServiciosViewController.m
//  Covisur
//
//  Created by Christian Fernandez on 17/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "PagoServiciosViewController.h"
#import "ConfirmacionServicioViewController.h"
#import "utilidades.h"
#import "CrearTarjetaViewController.h"
#import "RequestUrl.h"

@interface PagoServiciosViewController (){
    int tagPickerTarjeta;
}

@end

@implementation PagoServiciosViewController

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
    [self requestServerTarjetasCredito];
    [self.vistaNumeroPaso.layer setCornerRadius:self.vistaNumeroPaso.frame.size.width/2];
    [self.lblPaso setText:self.paso];
    [self.btnPagar.layer setCornerRadius:15.0];
    [self.lblValorTotal setText:self.valor];
    tagPickerTarjeta = 0;
    
    if (([[UIScreen mainScreen] bounds].size.height == 667)) {
        self.leadingVistaPaso.constant = self.leadingVistaPaso.constant + 5;
    }else if (([[UIScreen mainScreen] bounds].size.height == 736)) {
        self.leadingVistaPaso.constant = self.leadingVistaPaso.constant + 10;
    }
    [self.view layoutIfNeeded];
}

#pragma mark - IBActions

-(IBAction)btnVistaTarjeta:(id)sender{
    [[NSBundle mainBundle] loadNibNamed:@"VistaTarjeta" owner:self options:nil];
    [self.vistaTarjeta setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49)];
    [self.pickerTarjeta reloadAllComponents];
    [self.txtTarjetaCredito setText:[NSString stringWithFormat:@"%@ %@",[[_datatarjetas objectAtIndex:tagPickerTarjeta] objectForKey:@"nombre"],[utilidades processString:[[_datatarjetas objectAtIndex:tagPickerTarjeta] objectForKey:@"tarjeta"]]]];
    [self.view addSubview:self.vistaTarjeta];
    self.nidTarjeta = [NSString stringWithFormat:@"%@",[[_datatarjetas objectAtIndex:tagPickerTarjeta] objectForKey:@"nid"]];
    //[self.pickerTarjeta selectRow:tagPickerTarjeta inComponent:tagPickerTarjeta animated:NO];
}

-(IBAction)btnSeleccionarTarjeta:(id)sender{
    [self.vistaTarjeta removeFromSuperview];
    self.vistaTarjeta = nil;
}

-(IBAction)btnPagar:(id)sender{
    if ([self.txtTarjetaCredito.text isEqualToString:@""]) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Por favor seleccione una tarjeta para proceder con el pago" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
        [self requestServerCrearPago];
    }
}

-(IBAction)btnVolver:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnAgregarTarjeta:(id)sender{
    if ([_datatarjetas count] <= 3) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CrearTarjetaViewController *crearTarjetaViewController = [story instantiateViewControllerWithIdentifier:@"CrearTarjetaViewController"];
        crearTarjetaViewController.opcionTarjeta = @"crear";
        [self.navigationController pushViewController:crearTarjetaViewController animated:YES];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No puede crear mas de tres tarjetas con una cuenta" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
}

#pragma mark UiPicker Delegates

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// Total rows in our component.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_datatarjetas count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *title = [utilidades processString:[[_datatarjetas objectAtIndex:row] objectForKey:@"field_number_user_card"]];
    return title;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *title = @"";
    title = [NSString stringWithFormat:@"%@ %@",[[_datatarjetas objectAtIndex:row] objectForKey:@"field_payment_method"],[utilidades processString:[[_datatarjetas objectAtIndex:row] objectForKey:@"field_number_user_card"]]];
    tagPickerTarjeta = (int)row;
    self.txtTarjetaCredito.text = title;
    self.nidTarjeta = [NSString stringWithFormat:@"%@",[[_datatarjetas objectAtIndex:row] objectForKey:@"field_number_user_card"]];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
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

#pragma mark - WebService
#pragma mark - Consulta de Servicios

-(void)requestServerTarjetasCredito{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerTarjetasCredito) object:nil];
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

-(void)envioServerTarjetasCredito{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    //NSString * uid = @"85";  // Poner para Desarrollo
    NSString * uid = [_defaults objectForKey:@"uid"];//Poner para produccion
    
    NSMutableDictionary * dataTemporal = [RequestUrl obtenerTarjetasCredito:uid];
    [self performSelectorOnMainThread:@selector(ocultarCargandoTarjetasCredito:) withObject:dataTemporal waitUntilDone:YES];
}

-(void)ocultarCargandoTarjetasCredito:(NSMutableDictionary *)dataTemporal{
    if ([dataTemporal count]>0) {
        _datatarjetas = nil;
        _datatarjetas = [[dataTemporal objectForKey:@"list"] copy];
        [self.txtTarjetaCredito setText:[NSString stringWithFormat:@"%@ %@",[[_datatarjetas objectAtIndex:0] objectForKey:@"field_payment_method"],[utilidades processString:[[_datatarjetas objectAtIndex:0] objectForKey:@"field_number_user_card"]]]];
        self.nidTarjeta = [NSString stringWithFormat:@"%@",[[_datatarjetas objectAtIndex:tagPickerTarjeta] objectForKey:@"nid"]];
    }
    [self mostrarCargando];
}

#pragma mark - WebServices
#pragma mark - Pagar

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

#pragma mark - Pagar

-(void)requestServerCrearPago{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerCrearPago) object:nil];
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

-(void)envioServerCrearPago{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary * datosEnvio = [[NSMutableDictionary alloc] init];
    [datosEnvio setObject:@"payment_node_type" forKey:@"type"]; //Poner para desarrollo
    [datosEnvio setObject:[_defaults objectForKey:@"idServicio"] forKey:@"nid_service_order"];
    [datosEnvio setObject:self.nidTarjeta forKey:@"nid_credit_card"];
    
    NSMutableDictionary * dataServices = [RequestUrl crearPago:datosEnvio];
    [self performSelectorOnMainThread:@selector(ocultarCargandoCrearPago:) withObject:dataServices waitUntilDone:YES];
}

-(void)ocultarCargandoCrearPago:(NSMutableDictionary *)documentosTemporal{
    if ([documentosTemporal count]>0) {
        /*if ([documentosTemporal objectForKey:@"message"]) {
            
        }else{
            [self paso]
         }*/
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ConfirmacionServicioViewController *confirmacionServicioViewController = [story instantiateViewControllerWithIdentifier:@"ConfirmacionServicioViewController"];
        [self.navigationController pushViewController:confirmacionServicioViewController animated:YES];
    }else{
        
    }
}

@end
