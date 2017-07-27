//
//  MiCuentaViewController.m
//  Covisur
//
//  Created by Christian Fernandez on 7/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "MiCuentaViewController.h"
#import "utilidades.h"
#import "RequestUrl.h"

@interface MiCuentaViewController (){
    int tagPickerDocumento;
}

@end

@implementation MiCuentaViewController

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
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        
    }else if (([[UIScreen mainScreen] bounds].size.height == 667)) {
        self.heigthEliminarCuenta.constant = 40;
        [self.btnEliminarCuenta.layer setCornerRadius:20.0];
    }else if (([[UIScreen mainScreen] bounds].size.height == 736)) {
        self.heigthEliminarCuenta.constant = 40;
        [self.btnEliminarCuenta.layer setCornerRadius:20.0];
    }
    [self.view layoutIfNeeded];
    
    [self requestServerMiCuenta];
}

#pragma mark Own Methods

-(void)mostrarVistaPicker{
    [[NSBundle mainBundle] loadNibNamed:@"VistaTipoDocumento" owner:self options:nil];
    [self.pickerTipoCedula selectRow:tagPickerDocumento inComponent:0 animated:NO];
    [self.txtTipoIdentificacion setText:[[_dataTipoCedula objectAtIndex:tagPickerDocumento] objectForKey:@"name"]];
    [self.vistaTipoCedula setFrame:self.view.frame];
    [self.pickerTipoCedula reloadAllComponents];
    [self.tabBarController.view addSubview:self.vistaTipoCedula];
}

#pragma mark - IBAction

-(IBAction)btnVolver:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnVistaTipoDocumento:(id)sender{
    [self.view endEditing:TRUE];
    if (self.dataTipoCedula == nil) {
        [self requestServerTipoDocumento];
    }else{
        [self mostrarVistaPicker];
    }
}

-(IBAction)btnSeleccionarTipoDocumento:(id)sender{
    [self.vistaTipoCedula removeFromSuperview];
    self.vistaTipoCedula = nil;
}

-(IBAction)actualizarCuenta:(id)sender{
    if ([self.txtNombres.text isEqualToString:@""] || [self.txtApellidos.text isEqualToString:@""] || [self.txtTipoIdentificacion.text isEqualToString:@""] || [self.txtNumeroIdentificacion.text isEqualToString:@""] || [self.txtTelefono.text isEqualToString:@""] || [self.txtDireccion.text isEqualToString:@""] || [self.txtCorreo.text isEqualToString:@""]) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Por favor verifica que ningún campo se encuentre vacio" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
        if ([utilidades validateEmailWithString:self.txtCorreo.text]){
            if ([self.txtContrasena.text length] > 0 || [self.txtRepetirContrasena.text length]> 0){
                if ([self.txtContrasena.text isEqualToString:self.txtRepetirContrasena.text]) {
                    [self requestServerActualizarDatos];
                }else{
                    NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
                    [msgDict setValue:@"Atención" forKey:@"Title"];
                    [msgDict setValue:@"Por favor verifique que las contraseñas sean iguales" forKey:@"Message"];
                    [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
                    [msgDict setValue:@"" forKey:@"Cancel"];
                    
                    [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                        waitUntilDone:YES];
                }
            }else{
                [self requestServerActualizarDatos];
            }
        }else{
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"Por favor verifica el campo correo sea valido" forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"" forKey:@"Cancel"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }
    }
}

-(IBAction)btnDesactivarUsuario:(id)sender{
    [self requestServerDescativarCueta];
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

-(void)mostrarInformacion{
    [self.txtNombres setText:[_dataUsuario objectForKey:@"field_user_names"]];
    [self.txtApellidos setText:[_dataUsuario objectForKey:@"field_user_lastnames"]];
    NSMutableDictionary * tempDocumento = [_dataUsuario objectForKey:@"field_id_type"];
    [self.txtTipoIdentificacion setText:[tempDocumento objectForKey:@"id"]];
    self.idTipoDocumento = [tempDocumento objectForKey:@"id"];
    [self.txtNumeroIdentificacion setText:[_dataUsuario objectForKey:@"field_id_number"]];
    [self.txtTelefono setText:[_dataUsuario objectForKey:@"field_contact_number"]];
    [self.txtDireccion setText:[_dataUsuario objectForKey:@"field_address"]];
    [self.txtCorreo setText:[_dataUsuario objectForKey:@"mail"]];
    
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

#pragma mark Metodos TextField

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _txtSeleccionado = textField;
    _tViewSeleccionado = textField.superview;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([_txtNombres isEqual:textField]) {
        [_txtApellidos becomeFirstResponder];
    }else if ([_txtApellidos isEqual:textField]){
        [_txtTipoIdentificacion becomeFirstResponder];
    }else if ([_txtTipoIdentificacion isEqual:textField]){
        [_txtNumeroIdentificacion becomeFirstResponder];
    }else if ([_txtNumeroIdentificacion isEqual:textField]){
        [_txtTelefono becomeFirstResponder];
    }else if ([_txtTelefono isEqual:textField]){
        [_txtDireccion becomeFirstResponder];
    }else if ([_txtDireccion isEqual:textField]){
        [_txtCorreo becomeFirstResponder];
    }else if ([_txtCorreo isEqual:textField]){
        [self.view endEditing:TRUE];
    }else if ([_txtContrasena isEqual:textField]){
        [_txtRepetirContrasena becomeFirstResponder];
    }else if ([_txtRepetirContrasena isEqual:textField]){
        [self.view endEditing:TRUE];
    }
    return true;
}

#pragma mark - WebService
#pragma mark - Obtener Mi Cuenta

-(void)requestServerMiCuenta{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerMiCuenta) object:nil];
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

-(void)envioServerMiCuenta{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    _dataUsuario = [RequestUrl miCuenta:[_defaults objectForKey:@"uid"]];
    [self performSelectorOnMainThread:@selector(ocultarCargandoMiCuenta) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoMiCuenta{
    if ([_dataUsuario count]>0) {
        [self mostrarInformacion];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Algo sucedió, por favor intente mas tarde" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
    [self mostrarCargando];
}

#pragma mark UiPicker Delegates

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// Total rows in our component.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_dataTipoCedula count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *title = [[_dataTipoCedula objectAtIndex:row] objectForKey:@"name"];
    return title;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *title = @"";
    title=[[_dataTipoCedula objectAtIndex:row] objectForKey:@"name"];
    tagPickerDocumento = (int)row;
    self.txtTipoIdentificacion.text = title;
    self.idTipoDocumento = [[_dataTipoCedula objectAtIndex:row] objectForKey:@"tid"];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

#pragma mark - Obtener Tipo Documento

-(void)requestServerTipoDocumento{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerLogin) object:nil];
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

-(void)envioServerLogin{
    NSMutableDictionary * documentosTemporal = [RequestUrl tiposDocumentos];
    [self performSelectorOnMainThread:@selector(ocultarCargandoDocumentos:) withObject:documentosTemporal waitUntilDone:YES];
}

-(void)ocultarCargandoDocumentos:(NSMutableDictionary *)documentosTemporal{
    if ([documentosTemporal count]>0) {
        _dataTipoCedula = [[documentosTemporal objectForKey:@"list"] copy];
        [self mostrarVistaPicker];
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

#pragma mark - Actualizar datos

-(void)requestServerActualizarDatos{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerActualizarDatos) object:nil];
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

-(void)envioServerActualizarDatos{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * datosEnvio = [[NSMutableDictionary alloc] init];
    
    [datosEnvio setObject:[_defaults objectForKey:@"uid"] forKey:@"uid"];
    [datosEnvio setObject:self.txtCorreo.text forKey:@"mail"];
    [datosEnvio setObject:self.txtContrasena.text forKey:@"pass"];
    [datosEnvio setObject:self.txtNumeroIdentificacion.text forKey:@"field_id_number"];
    [datosEnvio setObject:self.idTipoDocumento forKey:@"field_id_type"];
    [datosEnvio setObject:self.txtNombres.text forKey:@"field_user_names"];
    [datosEnvio setObject:self.txtApellidos.text forKey:@"field_user_lastnames"];
    [datosEnvio setObject:self.txtDireccion.text forKey:@"field_address"];
    [datosEnvio setObject:self.txtTelefono.text forKey:@"field_contact_number"];
    _data = nil;
    _data = [RequestUrl actualizarCuenta:datosEnvio];
    [self performSelectorOnMainThread:@selector(ocultarCargandoActualizarDatos) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoActualizarDatos{
    NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
    [msgDict setValue:@"Atención" forKey:@"Title"];
    [msgDict setValue:@"Sus datos se han actualizado con éxito" forKey:@"Message"];
    [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
    [msgDict setValue:@"" forKey:@"Cancel"];
    
    [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                        waitUntilDone:YES];
    
    [self mostrarCargando];
}

#pragma mark - Desactivar Cuenta

-(void)requestServerDescativarCueta{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerDescativarCueta) object:nil];
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

-(void)envioServerDescativarCueta{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    _data = nil;
    _data = [RequestUrl eliminarUsuario:@"0" uid:[_defaults objectForKey:@"uid"]];
    [self performSelectorOnMainThread:@selector(ocultarCargandoDescativarCueta) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoDescativarCueta{
    if ([_data count]>0) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Sus datos se han actualizado con éxito" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Algo sucedió, por favor intente mas tarde" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
    [self mostrarCargando];
}

@end
