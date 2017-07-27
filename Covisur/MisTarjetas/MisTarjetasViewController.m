//
//  MisTarjetasViewController.m
//  Covisur
//
//  Created by Christian Fernandez on 7/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "MisTarjetasViewController.h"
#import "utilidades.h"
#import "CrearTarjetaViewController.h"
#import "RequestUrl.h"

@interface MisTarjetasViewController (){
    int indexBorrado;
    int pagina;
}

@end

@implementation MisTarjetasViewController

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self requestServerTarjetasCredito];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)configurerView{
    //[[NSBundle mainBundle] loadNibNamed:@"MisTarjetasFooterCell" owner:self options:nil];
    //[self.tblMisTarjetas setTableFooterView:self.misTarjetasFooterCell];
    
    [self.vistaBotonAgregar.layer setBorderWidth:1];
    [self.vistaBotonAgregar.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
}

#pragma mark - Own Methods

-(void)borrarTarjeta{
    [self requestServerTarjetasCredito];
}

#pragma mark - IBActions

-(IBAction)btnAgregarTarjeta:(id)sender{
    if ([_data count] <= 3) {
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

-(IBAction)btnAtras:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView Delegate & Datasrouce

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *CellIdentifier = @"MisTarjetasCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"MisTarjetasCell" owner:self options:nil];
        cell = _celdaTabla;
        self.celdaTabla = nil;
    }
    
    //[self.lblTarjetaCredito setText:[utilidades processString:[[_data objectAtIndex:indexPath.row] objectForKey:@"tarjeta"]]];
    [self.lblTarjetaCredito setText:[NSString stringWithFormat:@"%@ %@",[[_data objectAtIndex:indexPath.row] objectForKey:@"field_payment_method"],[[_data objectAtIndex:indexPath.row] objectForKey:@"field_number_user_card"]]];
    //[self.lblDescripcionComercio setText:[[self.dataComercio objectAtIndex:indexPath.row] objectForKey:@"NombreCategoria"]];
    
    [self.lblNombre setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"title"]];
    
    NSString * fechaExpiracion = [NSString stringWithFormat:@"%@/%@",[[_data objectAtIndex:indexPath.row] objectForKey:@"field_expiration_month_user_card"],[[_data objectAtIndex:indexPath.row] objectForKey:@"field_expiration_year_user_card"]];
    
    [self.lblFecha setText:fechaExpiracion];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
    NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
    if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex)) {
        [self.vistaLinea setHidden:FALSE];
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *editar = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"         " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        NSLog(@"Editar");
                                        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                        CrearTarjetaViewController *crearTarjetaViewController = [story instantiateViewControllerWithIdentifier:@"CrearTarjetaViewController"];
                                        crearTarjetaViewController.opcionTarjeta = @"editar";
                                        crearTarjetaViewController.datosTarjeta = [_data objectAtIndex:indexPath.row];
                                        [self.navigationController pushViewController:crearTarjetaViewController animated:YES];
                                    }];
    editar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"editar.png"]]; //arbitrary color
    
    UITableViewRowAction *eliminar = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"       " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                     {
                                         indexBorrado = (int)indexPath.row;
                                         NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
                                         [msgDict setValue:@"Atención" forKey:@"Title"];
                                         [msgDict setValue:@"¿Seguro que quieres eliminar esta tarjeta de credito?" forKey:@"Message"];
                                         [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
                                         [msgDict setValue:@"Cancelar" forKey:@"Cancel"];
                                         [msgDict setValue:@"101" forKey:@"Tag"];
                                         
                                         [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                                                             waitUntilDone:YES];
                                     }];
    eliminar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"eliminar.png"]]; //arbitrary color
    return @[eliminar, editar];
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
                                            //[self borrarTarjeta];
                                            [self requestServerEliminarTarjetasCredito];
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
    NSString * uid = [_defaults objectForKey:@"uid"]; //Poner para produccion
    
    NSMutableDictionary * dataTemporal = [RequestUrl obtenerTarjetasCredito:uid];
    [self performSelectorOnMainThread:@selector(ocultarCargandoTarjetasCredito:) withObject:dataTemporal waitUntilDone:YES];
}

-(void)ocultarCargandoTarjetasCredito:(NSMutableDictionary *)dataTemporal{
    if ([dataTemporal count]>0) {
        _data = nil;
        _data = [[dataTemporal objectForKey:@"list"] copy];
        [self.tblMisTarjetas reloadData];
        pagina += 1;
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene tarjetas de crédito asociadas a su cuenta" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
    [self mostrarCargando];
}

#pragma mark - Eliminar tarjeta

-(void)requestServerEliminarTarjetasCredito{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerEliminarTarjetasCredito) object:nil];
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

-(void)envioServerEliminarTarjetasCredito{
    NSString * nid = [[_data objectAtIndex:indexBorrado] objectForKey:@"nid"];  // Poner para Desarrollo
    //NSString * uid = [_defaults objectForKey:@"uid"] //Poner para produccion
    
    NSMutableDictionary * dataTemporal = [RequestUrl borrarTarjetasCredito:nid];
    [self performSelectorOnMainThread:@selector(ocultarCargandoEliminarTarjetasCredito:) withObject:dataTemporal waitUntilDone:YES];
}

-(void)ocultarCargandoEliminarTarjetasCredito:(NSMutableDictionary *)dataTemporal{
    if ([dataTemporal count]==0) {
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"Tarjeta de crédito eliminada con éxito" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
        [self requestServerTarjetasCredito];
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene tarjetas de crédito asociadas a su cuenta" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"" forKey:@"Cancel"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
    }
    [self mostrarCargando];
}

@end
