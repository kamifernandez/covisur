//
//  RegistroViewController.m
//  Covisur
//
//  Created by Christian Fernandez on 7/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "RegistroViewController.h"
#import "utilidades.h"
#import "MisTarjetasViewController.h"
#import "CerrarSesionViewController.h"
#import "InicioSesionViewController.h"
#import "RequestUrl.h"
#import "TerminosCondicionesViewController.h"


@interface RegistroViewController (){
    int tagPickerDocumento;
}

@end

@implementation RegistroViewController

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
    
    self.ladingCheckConstraint.constant = self.ladingCheckConstraint.constant;
    if (([[UIScreen mainScreen] bounds].size.height == 667)) {
        self.ladingCheckConstraint.constant = self.ladingCheckConstraint.constant + 25;
    }else if (([[UIScreen mainScreen] bounds].size.height == 736)) {
        self.ladingCheckConstraint.constant = self.ladingCheckConstraint.constant + 45;
    }
    [self.view layoutIfNeeded];
    
    tagPickerDocumento = 0;
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Siguiente"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(nextClick:)];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flexible,doneButton, nil]];
    self.txtNumeroIdentificacion.inputAccessoryView = keyboardDoneButtonView;
    
    self.txtTelefono.inputAccessoryView = keyboardDoneButtonView;

}

#pragma mark Own Methods

-(void)mostrarVistaPicker{
    [[NSBundle mainBundle] loadNibNamed:@"VistaTipoDocumento" owner:self options:nil];
    [self.pickerTipoCedula selectRow:tagPickerDocumento inComponent:0 animated:NO];
    [self.txtTipoIdentificacion setText:[[_dataTipoCedula objectAtIndex:tagPickerDocumento] objectForKey:@"name"]];
    [self.vistaTipoCedula setFrame:self.view.frame];
    [self.pickerTipoCedula reloadAllComponents];
    [self.view addSubview:self.vistaTipoCedula];
}

-(void)pasarHome{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *vc = [story instantiateViewControllerWithIdentifier:@"TabBar"];
    for (UITabBarItem* item in self.tabBarController.tabBar.items)
    {
        [item setTitlePositionAdjustment:UIOffsetMake(0, -10)];
    }
    [vc setDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
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
        [_txtCorreoConfirmacion becomeFirstResponder];
    }else if ([_txtCorreoConfirmacion isEqual:textField]){
        [_txtContrasena becomeFirstResponder];
    }else if ([_txtContrasena isEqual:textField]){
        [self.view endEditing:TRUE];
    }
    return true;
}

#pragma mark Metodos Teclado

-(void)mostrarTeclado:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.width-60, 0.0);
    _scroll.contentInset = contentInsets;
    _scroll.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = _scroll.frame;
    aRect.size.height -= kbSize.width;
    if (!CGRectContainsPoint(aRect, _tViewSeleccionado.frame.origin) ) {
        // El 160 es un parametro que depende de la vista en la que se encuentra, se debe ajustar dependiendo del caso
        float tamano = 0.0;
        
        float version=[[UIDevice currentDevice].systemVersion floatValue];
        if(version <7.0){
            tamano = _tViewSeleccionado.frame.origin.y-100;
        }else{
            tamano = _tViewSeleccionado.frame.origin.y-130;
        }
        if(tamano<0)
            tamano=0;
        CGPoint scrollPoint = CGPointMake(0.0, tamano);
        [_scroll setContentOffset:scrollPoint animated:YES];
    }
}

-(void)ocultarTeclado:(NSNotification*)aNotification
{
    [ UIView animateWithDuration:0.4f animations:^
     {
         UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
         _scroll.contentInset = contentInsets;
         _scroll.scrollIndicatorInsets = contentInsets;
     }completion:^(BOOL finished){
         
     }];
}

#pragma mark IBActions

- (void)nextClick:(id)sender
{
    if ([_txtSeleccionado isEqual:self.txtNumeroIdentificacion]) {
        [self.txtTelefono becomeFirstResponder];
    }else{
        [self.txtDireccion becomeFirstResponder];
    }
}

-(IBAction)btnPruebas:(id)sender{
    [self pasarHome];
}

-(IBAction)btnRegistro:(id)sender{
    if ([utilidades verifyEmpty:self.scroll]) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Por favor verifica que ningún campo se encuentre vacio" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
        if ([utilidades validateEmailWithString:self.txtCorreo.text]){
            
            if (![self.txtCorreo.text isEqualToString:self.txtCorreoConfirmacion.text]) {
                NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
                [msgDict setValue:@"Atención" forKey:@"Title"];
                [msgDict setValue:@"Por favor verifica que los campos de correo coincidan" forKey:@"Message"];
                [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
                [msgDict setValue:@"" forKey:@"Cancel"];
                
                [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                    waitUntilDone:YES];
            }else{
                    UIImage * imgComprare = [UIImage imageNamed:@"checkoff.png"];
                    NSData *imageDataCompare = UIImagePNGRepresentation(imgComprare);
                    NSData *imageData = UIImagePNGRepresentation(self.imgCheck.image);
                    if ([imageDataCompare isEqual:imageData]) {
                        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
                        [msgDict setValue:@"Atención" forKey:@"Title"];
                        [msgDict setValue:@"Antes de continuar por favor acepta los términos y condiciones" forKey:@"Message"];
                        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
                        [msgDict setValue:@"" forKey:@"Cancel"];
                        
                        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                            waitUntilDone:YES];
                    }else{
                        [self requestServerRegistrarUsuario];
                    }
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

-(IBAction)btnTerminos:(id)sender{
    UIImage * imgComprare = [UIImage imageNamed:@"checkoff.png"];
    NSData *imageDataCompare = UIImagePNGRepresentation(imgComprare);
    NSData *imageData = UIImagePNGRepresentation(self.imgCheck.image);
    if ([imageDataCompare isEqual:imageData]) {
        [self.imgCheck setImage:[UIImage imageNamed:@"check.png"]];
    }else{
        [self.imgCheck setImage:[UIImage imageNamed:@"checkoff.png"]];
    }
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
    [self.txtTipoIdentificacion setText:[[_dataTipoCedula objectAtIndex:tagPickerDocumento] objectForKey:@"name"]];
    self.tidDocumento = [[_dataTipoCedula objectAtIndex:tagPickerDocumento] objectForKey:@"tid"];
    [self.vistaTipoCedula removeFromSuperview];
    self.vistaTipoCedula = nil;
}

-(IBAction)volver:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)verTerminosCondicinones:(id)sender{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TerminosCondicionesViewController *vc = [story instantiateViewControllerWithIdentifier:@"TerminosCondicionesViewController"];
    [self.navigationController pushViewController:vc animated:YES];
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
    self.tidDocumento = [[_dataTipoCedula objectAtIndex:row] objectForKey:@"tid"];
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
                                        if ([[msgDict objectForKey:@"Tag"] isEqualToString:@"101"]) {
                                            NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
                                            [_defaults setObject:@"NO" forKey:@"login"];
                                            for (UIViewController *controller in self.navigationController.viewControllers) {
                                                
                                                //Do not forget to import AnOldViewController.h
                                                if ([controller isKindOfClass:[InicioSesionViewController class]]) {
                                                    
                                                    [self.navigationController popToViewController:controller
                                                                                          animated:YES];
                                                    break;
                                                }
                                            }
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
                                        
                                    }];
        
        [alert addAction:yesButton];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Custom Tab

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex == 0)
    {
        // First Tab is selected do something
    }else if (tabBarController.selectedIndex == 1){
        NSLog(@"Prueba");
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[CerrarSesionViewController class]]) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Cerrar Sesión" forKey:@"Title"];
        [msgDict setValue:@"Esta seguro que desea cerrar sesión" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"Cancelar" forKey:@"Cancel"];
        [msgDict setValue:@"101" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
        return NO;
    }
    return YES;
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

#pragma mark - Registrar Usuario

-(void)requestServerRegistrarUsuario{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerRegistroUsuario) object:nil];
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

-(void)envioServerRegistroUsuario{
    NSMutableDictionary * datosEnvio = [[NSMutableDictionary alloc] init];
    [datosEnvio setObject:self.txtContrasena.text forKey:@"pass"];
    [datosEnvio setObject:self.txtCorreo.text forKey:@"mail"];
    [datosEnvio setObject:self.txtNumeroIdentificacion.text forKey:@"field_id_number"];
    [datosEnvio setObject:self.tidDocumento forKey:@"field_id_type"];
    [datosEnvio setObject:self.txtNombres.text forKey:@"field_user_names"];
    [datosEnvio setObject:self.txtApellidos.text forKey:@"field_user_lastnames"];
    [datosEnvio setObject:self.txtDireccion.text forKey:@"field_address"];
    [datosEnvio setObject:self.txtTelefono.text forKey:@"field_contact_number"];
    
    _data = [RequestUrl crearUsuario:datosEnvio];
    [self performSelectorOnMainThread:@selector(ocultarCargandoRegistroUsuario) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoRegistroUsuario{
    if ([_data count]>0) {
        NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
        [_defaults setObject:[_data objectForKey:@"id"] forKey:@"uid"];
        [_defaults setObject:self.txtNombres.text forKey:@"name"];
        [_defaults setObject:self.txtCorreo.text forKey:@"mail"];
        [_defaults setObject:@"YES" forKey:@"login"];
        NSLog(@"Registro con exito %@",[_defaults objectForKey:@"uid"]);
        [self pasarHome];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"El usuario con el que intenta registrarse ya se encuentra activo" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
    [self mostrarCargando];
}

#pragma mark - Variables Globales

-(void)requestServerGolbales{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerGolbales) object:nil];
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

-(void)envioServerGolbales{
    _data = nil;
    _data = [RequestUrl variablesGlobales];
    [self performSelectorOnMainThread:@selector(ocultarCargandoGolbales) withObject:nil waitUntilDone:YES];
}

-(void)ocultarCargandoGolbales{
    if ([_data count]>0) {
        NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
        [_defaults setObject:[_data objectForKey:@"no_work_days"] forKey:@"no_work_days"];
        [_defaults setObject:[_data objectForKey:@"start_hour"] forKey:@"start_hour"];
        [_defaults setObject:[_data objectForKey:@"finish_hour"] forKey:@"finish_hour"];
        int diasMinimos = [[_data objectForKey:@"min_day_schedule"] intValue];
        diasMinimos = diasMinimos/24;
        [_defaults setObject:[NSString stringWithFormat:@"%i",diasMinimos] forKey:@"min_day_schedule"];
        [_defaults setObject:[_data objectForKey:@"max_day_schedule"] forKey:@"max_day_schedule"];
        [_defaults setObject:[_data objectForKey:@"level_risk"] forKey:@"level_risk"];
        [_defaults setObject:[_data objectForKey:@"level_risk_msg"] forKey:@"level_risk_msg"];
        [_defaults setObject:[_data objectForKey:@"time_delete_schedule"] forKey:@"time_delete_schedule"];
    }else{
        [self requestServerGolbales];
    }
}


@end
