//
//  CrearTarjetaViewController.m
//  Covisur
//
//  Created by Christian Fernandez on 7/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "CrearTarjetaViewController.h"
#import "RequestUrl.h"
#import "utilidades.h"
#import "Luhn.h"

@interface CrearTarjetaViewController (){
    BOOL titularTarjeta;
    int tagPickerDocumento;
    int pickerSeleccionado;
}

@end

@implementation CrearTarjetaViewController

-(void)viewWillAppear:(BOOL)animated
{
    // Notificationes que se usan para cuando se muestra y se esconde el teclado
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mostrarTeclado:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocultarTeclado:) name:UIKeyboardDidHideNotification object:nil];
    [super viewWillAppear:NO];
}

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
    pickerSeleccionado = 0;
    [self.vistaNombreTitular setHidden:TRUE];
    [self.vistaDocumentoTitular setHidden:TRUE];
    [self.vistaTelefonoTitular setHidden:TRUE];
    [self.vistaCorreoTitular setHidden:TRUE];
    [self.vistaDireccionTitular setHidden:TRUE];
    [self.vistaCiudadTitular setHidden:TRUE];
    titularTarjeta = YES;
    if ([self.opcionTarjeta isEqualToString:@"crear"]) {
        [self.lblTitulo setText:@"Crear tarjeta"];
    }else{
        [self.lblTitulo setText:@"Editar tarjeta"];
        
        [self.txtnombreTarjeta setText:[_datosTarjeta objectForKey:@"field_payment_method"]];
        [self.txtNumeroTarjeta setText:[_datosTarjeta objectForKey:@"field_number_user_card"]];
        NSString * fechaExpiracion = [_datosTarjeta objectForKey:@"field_expiration_month_user_card"];
        if ([fechaExpiracion length] == 1) {
            fechaExpiracion = [NSString stringWithFormat:@"0%@",fechaExpiracion];
        }
        [self.txtMesExpiracion setText:fechaExpiracion];
        [self.txtAnoExpiracion setText:[_datosTarjeta objectForKey:@"field_expiration_year_user_card"]];
        [self.txtCodigoSeguridad setText:[_datosTarjeta objectForKey:@"nid"]];
    }
    self.hegitContentScroll.constant = 150;
    [self.scroll layoutIfNeeded];
    
    [self.scroll setScrollEnabled:false];
    
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Siguiente"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(nextClick:)];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flexible,doneButton, nil]];
    self.txtNumeroTarjeta.inputAccessoryView = keyboardDoneButtonView;
    self.txtCodigoSeguridad.inputAccessoryView = keyboardDoneButtonView;
    self.txtMesExpiracion.inputAccessoryView = keyboardDoneButtonView;
    self.txtAnoExpiracion.inputAccessoryView = keyboardDoneButtonView;
    self.txtTelefonoTitular.inputAccessoryView = keyboardDoneButtonView;
    
    if (([[UIScreen mainScreen] bounds].size.height == 667)) {
        self.leadingCheck.constant = self.leadingCheck.constant + 25;
    }else if (([[UIScreen mainScreen] bounds].size.height == 736)) {
        self.leadingCheck.constant = self.leadingCheck.constant + 45;
    }
    [self.view layoutIfNeeded];
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    //self.scroll.contentSize = CGSizeMake(0, 600);
}

#pragma mark Own Methods

-(void)mostrarVistaPicker{
    [[NSBundle mainBundle] loadNibNamed:@"VistaTipoDocumento" owner:self options:nil];
    [self.pickerTipoCedula selectRow:0 inComponent:0 animated:NO];
    [self.vistaTipoCedula setFrame:self.view.frame];
    [self.pickerTipoCedula reloadAllComponents];
    [self.tabBarController.view addSubview:self.vistaTipoCedula];
}

#pragma mark - IBActions

-(IBAction)btnPickerMothn:(id)sender{
    [self.view endEditing:YES];
    pickerSeleccionado = 0;
    _dataPicker = nil;
    _dataPicker = [[NSMutableArray alloc] init];
    for (int i=1; i<=12; i++) {
        NSString * mes = [NSString stringWithFormat:@"%d",i];
        if ([mes length] == 1) {
            mes = [NSString stringWithFormat:@"0%@",mes];
        }
        [_dataPicker addObject:mes];
    }
    [self.txtMesExpiracion setText:[_dataPicker objectAtIndex:0]];
    [self mostrarVistaPicker];
}

-(IBAction)btnPickerYear:(id)sender{
    [self.view endEditing:YES];
    pickerSeleccionado = 1;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    int i2  = [[formatter stringFromDate:[NSDate date]] intValue];
    int anosCulminacion = i2 + 25;
    _dataPicker = nil;
    _dataPicker = [[NSMutableArray alloc] init];
    for (int i=i2; i<=anosCulminacion; i++) {
        [_dataPicker addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self.txtAnoExpiracion setText:[_dataPicker objectAtIndex:0]];
    [self mostrarVistaPicker];
}

-(IBAction)btnSeleccionarTipoDocumento:(id)sender{
    [self.vistaTipoCedula removeFromSuperview];
    self.vistaTipoCedula = nil;
}

-(IBAction)btnNoPropietario:(id)sender{
    UIImage * imgComprare = [UIImage imageNamed:@"checkoff.png"];
    NSData *imageDataCompare = UIImagePNGRepresentation(imgComprare);
    NSData *imageData = UIImagePNGRepresentation(self.imgCheck.image);
    if ([imageDataCompare isEqual:imageData]) {
        titularTarjeta = NO;
        [self.imgCheck setImage:[UIImage imageNamed:@"check.png"]];
        self.hegitContentScroll.constant = 0;
        [self.scroll layoutIfNeeded];
        
        [self.scroll setScrollEnabled:true];
        
        [self.vistaNombreTitular setHidden:FALSE];
        [self.vistaDocumentoTitular setHidden:FALSE];
        [self.vistaTelefonoTitular setHidden:FALSE];
        [self.vistaCorreoTitular setHidden:FALSE];
        [self.vistaDireccionTitular setHidden:FALSE];
        [self.vistaCiudadTitular setHidden:FALSE];
        
    }else{
        [self.view endEditing:TRUE];
        [self.vistaNombreTitular setHidden:TRUE];
        [self.vistaDocumentoTitular setHidden:TRUE];
        [self.vistaTelefonoTitular setHidden:TRUE];
        [self.vistaCorreoTitular setHidden:TRUE];
        [self.vistaDireccionTitular setHidden:TRUE];
        [self.vistaCiudadTitular setHidden:TRUE];
        titularTarjeta = YES;
        [self.scroll setContentOffset:CGPointZero animated:YES];
        [self.imgCheck setImage:[UIImage imageNamed:@"checkoff.png"]];
        self.hegitContentScroll.constant = 150;
        [self.scroll layoutIfNeeded];
        
        [self.scroll setScrollEnabled:false];
    }
}

-(IBAction)btnCrearTarjeta:(id)sender{
    bool datosVacios = NO;
    if (titularTarjeta) {
        if ([self.txtnombreTarjeta.text isEqualToString:@""] || [self.txtNumeroTarjeta.text isEqualToString:@""] || [self.txtNumeroTarjeta.text isEqualToString:@""] || [self.txtMesExpiracion.text isEqualToString:@""] || [self.txtAnoExpiracion.text isEqualToString:@""] || [self.txtCodigoSeguridad.text isEqualToString:@""]) {
            datosVacios = YES;
        }
    }else{
        if ([utilidades verifyEmpty:self.scroll]) {
            datosVacios = YES;
        }
    }
    
    OLCreditCardType cardType = [self.txtNumeroTarjeta.text creditCardType];
    self.marcaTarjeta = [utilidades cardText:cardType];
    
    if (self.marcaTarjeta != nil) {
        if (titularTarjeta) {
            if (datosVacios) {
                NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
                [msgDict setValue:@"Atención" forKey:@"Title"];
                [msgDict setValue:@"Por favor verifica que ningún campo se encuentre vacio" forKey:@"Message"];
                [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
                [msgDict setValue:@"" forKey:@"Cancel"];
                
                [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                    waitUntilDone:YES];
            }else{
                if ([self.opcionTarjeta isEqualToString:@"crear"]) {
                    [self requestServerCrearTarjeta];
                }else{
                    [self requestServerActualizarTarjeta];
                }
            }
        }else{
            if ([utilidades validateEmailWithString:self.txtCorreoTitular.text]){
                if ([self.opcionTarjeta isEqualToString:@"crear"]) {
                    [self requestServerCrearTarjeta];
                }else{
                    [self requestServerActualizarTarjeta];
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
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Por favor asegúrese que el numero de la tarjeta sea valido" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
}

- (void)nextClick:(id)sender
{
    if ([_txtSeleccionado isEqual:self.txtNumeroTarjeta]) {
        //[self.txtNombresApellidos becomeFirstResponder];
        [self.view endEditing:TRUE];
    }else if([_txtSeleccionado isEqual:self.txtCodigoSeguridad]){
        if (titularTarjeta) {
            [self.scroll setContentOffset:CGPointZero animated:YES];
            [self.view endEditing:TRUE];
        }else{
            [_txtNombreTitular becomeFirstResponder];
        }
    }else if ([_txtSeleccionado isEqual:self.txtTelefonoTitular]){
        [self.txtCorreoTitular becomeFirstResponder];
    }else if ([_txtMesExpiracion isEqual:self.txtSeleccionado]){
        [self.txtAnoExpiracion becomeFirstResponder];
    }else if ([_txtAnoExpiracion isEqual:self.txtSeleccionado]){
        [self.txtCodigoSeguridad becomeFirstResponder];
    }
}

-(IBAction)btnVolver:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Metodos TextField

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _txtSeleccionado = textField;
    _tViewSeleccionado = textField.superview;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([_txtnombreTarjeta isEqual:textField]) {
        [_txtNumeroTarjeta becomeFirstResponder];
    }else if ([_txtNumeroTarjeta isEqual:textField]){
        [self.view endEditing:TRUE];
    }else if ([_txtCodigoSeguridad isEqual:textField]){
        if (titularTarjeta) {
            [self.view endEditing:TRUE];
        }else{
            [_txtNombreTitular becomeFirstResponder];
        }
    }else if ([_txtNombreTitular isEqual:textField]){
        [_txtDocumentoTitular becomeFirstResponder];
    }else if ([_txtDocumentoTitular isEqual:textField]){
        [_txtTelefonoTitular becomeFirstResponder];
    }else if ([_txtTelefonoTitular isEqual:textField]){
        [_txtCorreoTitular becomeFirstResponder];
    }else if ([_txtCorreoTitular isEqual:textField]){
        [_txtDireccionTitular becomeFirstResponder];
    }else if ([_txtDireccionTitular isEqual:textField]){
        [_txtCiudadTitular becomeFirstResponder];
    }else if ([_txtCiudadTitular isEqual:textField]){
        [self.view endEditing:TRUE];
    }
    return true;
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([textField isEqual:_txtAnoExpiracion] || [textField isEqual:_txtMesExpiracion]) {
        NSUInteger maxLength = 0;
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        if ([textField isEqual:_txtAnoExpiracion]) {
            maxLength = 4;
        }else if ([textField isEqual:_txtMesExpiracion]){
            maxLength = 2;
        }
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= maxLength || returnKey;
    }
    return YES;
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
                                        if ([[msgDict objectForKey:@"Tag"] isEqualToString:@"101"]) {
                                            [self btnVolver:0];
                                        }
                                    }];
        
        [alert addAction:yesButton];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark UiPicker Delegates

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// Total rows in our component.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_dataPicker count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *title = [_dataPicker objectAtIndex:row];
    return title;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *title = @"";
    title=[_dataPicker objectAtIndex:row];
    tagPickerDocumento = (int)row;
    if (pickerSeleccionado == 0) {
        self.txtMesExpiracion.text = [_dataPicker objectAtIndex:row];
    }else{
        self.txtAnoExpiracion.text = [_dataPicker objectAtIndex:row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
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
#pragma mark - Crear Tarjeta

-(void)requestServerCrearTarjeta{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerCrearTarjeta) object:nil];
        [queue1 addOperation:operation];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene conexión a internet" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
}

-(void)envioServerCrearTarjeta{
    NSMutableDictionary * datosEnvio = [[NSMutableDictionary alloc] init];
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    [datosEnvio setObject:[_defaults objectForKey:@"uid"] forKey:@"uid"]; //Poner para produccion
    
    [datosEnvio setObject:@"credit_card_node_type" forKey:@"type"];
    //[datosEnvio setObject:@"85" forKey:@"uid"]; // Poner para Desarrollo
    [datosEnvio setObject:self.txtnombreTarjeta.text forKey:@"credit_card_name"];
    [datosEnvio setObject:self.txtNumeroTarjeta.text forKey:@"credit_card_number"];
    [datosEnvio setObject:self.txtMesExpiracion.text forKey:@"credit_card_number_month"];
    [datosEnvio setObject:self.txtAnoExpiracion.text forKey:@"credit_card_number_year"];
    [datosEnvio setObject:self.txtCodigoSeguridad.text forKey:@"credit_card_security_code"];
    [datosEnvio setObject:@"NO" forKey:@"opcionales"];
    [datosEnvio setObject:self.marcaTarjeta forKey:@"credit_card_brand"];
    
    if (titularTarjeta == NO) {
        [datosEnvio setObject:self.txtNombreTitular.text forKey:@"field_name_user_card"];
        [datosEnvio setObject:self.txtTelefonoTitular.text forKey:@"field_celphone"];
        [datosEnvio setObject:self.txtCorreoTitular.text forKey:@"field_email_user_card"];
        [datosEnvio setObject:self.txtDocumentoTitular.text forKey:@"field_id_user_card"];
        [datosEnvio setObject:self.txtDireccionTitular.text forKey:@"field_address_user_card"];
        [datosEnvio setObject:@"SI" forKey:@"opcionales"];
    }
    
    NSMutableDictionary * dataTemporal = [RequestUrl crearTarjetasCredito:datosEnvio];
    [self performSelectorOnMainThread:@selector(ocultarCargandoCrearTarjeta:) withObject:dataTemporal waitUntilDone:YES];
}

-(void)ocultarCargandoCrearTarjeta:(NSMutableDictionary *)dataTemporal{
    if ([dataTemporal count]>0) {
        if ([dataTemporal objectForKey:@"message"]) {
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:[dataTemporal objectForKey:@"message"] forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"" forKey:@"Cancel"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }else{
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"Tarjeta creada con éxito" forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"" forKey:@"Cancel"];
            [msgDict setValue:@"101" forKey:@"Tag"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene ordenes activas para mostrar" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
    [self mostrarCargando];
}

#pragma mark - Actualizar Tarjeta

-(void)requestServerActualizarTarjeta{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerActualizarTarjeta) object:nil];
        [queue1 addOperation:operation];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene conexión a internet" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
}

-(void)envioServerActualizarTarjeta{
    NSMutableDictionary * datosEnvio = [[NSMutableDictionary alloc] init];
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    [datosEnvio setObject:[_defaults objectForKey:@"uid"] forKey:@"uid"]; //Poner para produccion
    
    [datosEnvio setObject:@"credit_card_node_type" forKey:@"type"];
    //[datosEnvio setObject:@"85" forKey:@"uid"]; // Poner para Desarrollo
    [datosEnvio setObject:self.txtnombreTarjeta.text forKey:@"credit_card_name"];
    [datosEnvio setObject:self.txtNumeroTarjeta.text forKey:@"credit_card_number"];
    [datosEnvio setObject:self.txtMesExpiracion.text forKey:@"credit_card_number_month"];
    [datosEnvio setObject:self.txtAnoExpiracion.text forKey:@"credit_card_number_year"];
    [datosEnvio setObject:self.txtCodigoSeguridad.text forKey:@"credit_card_security_code"];
    [datosEnvio setObject:self.txtnombreTarjeta.text forKey:@"credit_card_brand"];
    [datosEnvio setObject:@"NO" forKey:@"opcionales"];
    [datosEnvio setObject:self.marcaTarjeta forKey:@"field_payment_method"];
    
    if (titularTarjeta == NO) {
        [datosEnvio setObject:self.txtNombreTitular.text forKey:@"field_name_user_card"];
        [datosEnvio setObject:self.txtTelefonoTitular.text forKey:@"field_celphone"];
        [datosEnvio setObject:self.txtCorreoTitular.text forKey:@"field_email_user_card"];
        [datosEnvio setObject:self.txtDocumentoTitular.text forKey:@"field_id_user_card"];
        [datosEnvio setObject:self.txtDireccionTitular.text forKey:@"field_address_user_card"];
        [datosEnvio setObject:@"SI" forKey:@"opcionales"];
    }
    
    NSMutableDictionary * dataTemporal = [RequestUrl crearTarjetasCredito:datosEnvio];
    [self performSelectorOnMainThread:@selector(ocultarCargandoActualizarTarjeta:) withObject:dataTemporal waitUntilDone:YES];
}

-(void)ocultarCargandoActualizarTarjeta:(NSMutableDictionary *)dataTemporal{
    if ([dataTemporal count]>0) {
        if ([dataTemporal objectForKey:@"message"]) {
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:[dataTemporal objectForKey:@"message"] forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"" forKey:@"Cancel"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }else{
            NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
            [msgDict setValue:@"Atención" forKey:@"Title"];
            [msgDict setValue:@"Tarjeta creada con éxito" forKey:@"Message"];
            [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
            [msgDict setValue:@"" forKey:@"Cancel"];
            [msgDict setValue:@"101" forKey:@"Tag"];
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                waitUntilDone:YES];
        }
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene ordenes activas para mostrar" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
    [self mostrarCargando];
}

@end
