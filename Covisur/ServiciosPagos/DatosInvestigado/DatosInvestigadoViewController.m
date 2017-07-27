//
//  DatosInvestigadoViewController.m
//  Covisur
//
//  Created by Christian Fernandez on 14/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "DatosInvestigadoViewController.h"
#import "SeleccionServiciosViewController.h"
#import "RequestUrl.h"
#import "utilidades.h"

@interface DatosInvestigadoViewController (){
    int tagPickerDocumento;
}

@end

@implementation DatosInvestigadoViewController

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
    
    [self.vistaNumeroPaso.layer setCornerRadius:self.vistaNumeroPaso.frame.size.width/2];
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

-(void)mostrarVistaPicker{
    [[NSBundle mainBundle] loadNibNamed:@"VistaTipoDocumento" owner:self options:nil];
    [self.pickerTipoCedula selectRow:tagPickerDocumento inComponent:0 animated:NO];
    [self.vistaTipoCedula setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49)];
    [self.txtTipoIdentificacion setText:[[_dataTipoCedula objectAtIndex:tagPickerDocumento] objectForKey:@"name"]];
    self.tidDocumento = [[_dataTipoCedula objectAtIndex:tagPickerDocumento] objectForKey:@"tid"];
    [self.pickerTipoCedula reloadAllComponents];
    [self.view addSubview:self.vistaTipoCedula];
}

-(void)sigueintePaso{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SeleccionServiciosViewController *seleccionServiciosViewController = [story instantiateViewControllerWithIdentifier:@"SeleccionServiciosViewController"];
    seleccionServiciosViewController.dataInvestigado = self.dataEnvio;
    [self.navigationController pushViewController:seleccionServiciosViewController animated:YES];
}

#pragma mark IBActions

- (void)nextClick:(id)sender
{
    if ([_txtSeleccionado isEqual:self.txtNumeroIdentificacion]) {
        [self.txtNombresApellidos becomeFirstResponder];
    }else{
        [self.view endEditing:TRUE];
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
    [self.vistaTipoCedula removeFromSuperview];
    self.vistaTipoCedula = nil;
}

-(IBAction)btnsiguiente:(id)sender{
    if ([utilidades verifyEmpty:self.scroll]) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Por favor verifica que ningún campo se encuentre vacio" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }else{
        self.dataEnvio = [[NSMutableDictionary alloc] init];
        
        [self.dataEnvio setObject:self.txtTipoIdentificacion.text forKey:@"tipoIdentificacion"];
        [self.dataEnvio setObject:self.txtNumeroIdentificacion.text forKey:@"numeroIdentificacion"];
        [self.dataEnvio setObject:self.txtNombresApellidos.text forKey:@"nombres"];
        [self.dataEnvio setObject:self.txtNumeroIdentificacion.text forKey:@"numero"];
        
        NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
        [_defaults setObject:self.txtTipoIdentificacion.text forKey:@"tipodocumento"];
        [_defaults setObject:self.txtNumeroIdentificacion.text forKey:@"numerodocumento"];
        [_defaults setObject:self.txtNombresApellidos.text forKey:@"nombres"];
        [_defaults setObject:self.txtTelefono.text forKey:@"telefono"];
        
        self.dataEnvio = nil;
        
        [self requestServerEnviarInvestigado];
    }
}

-(IBAction)btnAtras:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Metodos TextField

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _txtSeleccionado = textField;
    _tViewSeleccionado = textField.superview;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([_txtTipoIdentificacion isEqual:textField]){
        [_txtNumeroIdentificacion becomeFirstResponder];
    }else if ([_txtNumeroIdentificacion isEqual:textField]){
        [_txtNombresApellidos becomeFirstResponder];
    }else if ([_txtNombresApellidos isEqual:textField]){
        [_txtTelefono becomeFirstResponder];
    }else if ([_txtTelefono isEqual:textField]){
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


#pragma mark - Enviar investigado

-(void)requestServerEnviarInvestigado{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerEnviarInvestigado) object:nil];
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

-(void)envioServerEnviarInvestigado{
    NSMutableDictionary * datosEnvio = [[NSMutableDictionary alloc] init];
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    [datosEnvio setObject:[_defaults objectForKey:@"uid"] forKey:@"uid"]; //Poner para produccion
    //[datosEnvio setObject:@"85" forKey:@"uid"]; //Poner para desarrollo
    [datosEnvio setObject:@"service_orders" forKey:@"type"];
    [datosEnvio setObject:self.tidDocumento forKey:@"field_id_type"];
    [datosEnvio setObject:self.txtNumeroIdentificacion.text forKey:@"field_id_number_to_investigate"];
    [datosEnvio setObject:self.txtNombresApellidos.text forKey:@"field_first_and_lastnames"];
    [datosEnvio setObject:self.txtTelefono.text forKey:@"field_contact_number"];
    
    NSMutableDictionary * dataTemporal = [RequestUrl enviarDatosInvestigado:datosEnvio];
    [self performSelectorOnMainThread:@selector(ocultarCargandoEnviarInvestigado:) withObject:dataTemporal waitUntilDone:YES];
}

-(void)ocultarCargandoEnviarInvestigado:(NSMutableDictionary *)dataTemporal{
    if ([dataTemporal count]>0) {
        NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
        [_defaults setObject:[dataTemporal objectForKey:@"id"] forKey:@"idServicio"];
        [self sigueintePaso];
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
