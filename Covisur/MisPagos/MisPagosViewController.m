//
//  MisPagosViewController.m
//  Covisur
//
//  Created by Christian Fernandez on 21/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import "MisPagosViewController.h"
#import "NSMutableAttributedString+Color.h"
#import "utilidades.h"
#import "RequestUrl.h"

@interface MisPagosViewController ()

@end

@implementation MisPagosViewController

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
    
    if ([self.ventana isEqualToString:@"SI"]) {
        [self.btnVolver setHidden:FALSE];
    }
    [self requestServerMisPagos];
}

#pragma mark - IBActions

-(IBAction)btnVolver:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnDescargar:(id)sender{
    NSInteger tagButton = [sender tag];
    [self mostrarCargando];
    if ([MFMailComposeViewController canSendMail]) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSString *imageURL = [[_data objectAtIndex:tagButton] objectForKey:@"field_pdf_path"];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
            dispatch_sync(dispatch_get_main_queue(), ^{
                MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
                [composeViewController setMailComposeDelegate:self];
                [composeViewController setToRecipients:@[@"example@email.com"]];
                [composeViewController setSubject:[NSString stringWithFormat:@"Detalle pago %@",[[_data objectAtIndex:tagButton] objectForKey:@"orden"]]];
                [composeViewController addAttachmentData:data mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"%@.pdf",[[_data objectAtIndex:tagButton] objectForKey:@"title"]]];
                [self presentViewController:composeViewController animated:YES completion:nil];
                [self mostrarCargando];
            });
        });
    }else{
        NSMutableDictionary *msgDict=[[NSMutableDictionary alloc] init];
        [msgDict setValue:@"Atención" forKey:@"Title"];
        [msgDict setValue:@"No tiene configurada una cuenta de correo, por favor configure su cuenta y vuelve a intentarlo" forKey:@"Message"];
        [msgDict setValue:@"Aceptar" forKey:@"Aceptar"];
        [msgDict setValue:@"100" forKey:@"Tag"];
        
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:msgDict
                            waitUntilDone:YES];
        [self mostrarCargando];
    }
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
    static NSString *CellIdentifier = @"";
    
    CellIdentifier = @"MisPagosTableViewCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"MisPagosTableViewCell" owner:self options:nil];
        cell = _celdaTabla;
        self.celdaTabla = nil;
    }
    [self.lblService setText:[[_data objectAtIndex:indexPath.row] objectForKey:@"title"]];
    
    NSArray * dateSplit = [[[_data objectAtIndex:indexPath.row] objectForKey:@"field_transaction_date"] componentsSeparatedByString:@" "];
    
    NSString * fecha = [[dateSplit objectAtIndex:0] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    
    [self.lblFecha setText:fecha];
    
    //int totalServicios = [[[_data objectAtIndex:indexPath.row] objectForKey:@"field_order_total"] intValue];
    
    //[self.lblValor setText:[NSString stringWithFormat:@"Valor Total $%@",[utilidades decimalNumberFormat:totalServicios]]];
    
    [self.lblValor setText:[NSString stringWithFormat:@"Valor Total %@",[[_data objectAtIndex:indexPath.row] objectForKey:@"field_order_total"]]];
    
    NSMutableArray * tempServices = [[_data objectAtIndex:indexPath.row] objectForKey:@"services_buyed"];
    
    int yVista = 120;
    for (int i = 0; i<[tempServices count]; i++) {
        UIView * vista = [[UIView alloc] init];
        [vista setFrame:CGRectMake(60, yVista, 200, 30)];
        
        UILabel * lblServicio = [[UILabel alloc] init];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"* %@",[[tempServices objectAtIndex:i] objectForKey:@"servicio"]]];
        [string setColorForText:@"*" withColor:[UIColor colorWithRed:102.0/255.0 green:168.0/255.0 blue:223.0/255.0 alpha:1]];
        [string setColorForText:[[tempServices objectAtIndex:i] objectForKey:@"servicio"] withColor:[UIColor colorWithRed:93.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1]];
        
        [lblServicio setAttributedText:string];
        [lblServicio setFrame:CGRectMake(0, 0, 200, 20)];
        [lblServicio setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        
        [vista addSubview:lblServicio];
        [cell addSubview:vista];
        
        yVista += 30;
    }
    [self.btnDescargar setTag:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray * tempServices = [[_data objectAtIndex:indexPath.row] objectForKey:@"services_buyed"];
    
    int countData = (int)[tempServices count];
    
    int heigthRow = 120;
    
    heigthRow += countData * 30;
    
    heigthRow += 50;
    
    return heigthRow;
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

#pragma mark - Mail Composer Delegates

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - Obtener Mis Pagos

-(void)requestServerMisPagos{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    if ([[_defaults objectForKey:@"connectioninternet"] isEqualToString:@"YES"]) {
        [self mostrarCargando];
        NSOperationQueue * queue1 = [[NSOperationQueue alloc] init];
        [queue1 setMaxConcurrentOperationCount:1];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(envioServerMisPagos) object:nil];
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

-(void)envioServerMisPagos{
    NSUserDefaults * _defaults = [NSUserDefaults standardUserDefaults];
    //NSString * uid = @"85";  // Desarrollo
    NSString * uid = [_defaults objectForKey:@"uid"];  // Produccion
    NSMutableDictionary * dataServices = [RequestUrl MisServiciosPagos:uid];
    [self performSelectorOnMainThread:@selector(ocultarCargandoMisPagos:) withObject:dataServices waitUntilDone:YES];
}

-(void)ocultarCargandoMisPagos:(NSMutableDictionary *)documentosTemporal{
    if ([documentosTemporal count]>0) {
        _data = nil;
        _data = [[documentosTemporal objectForKey:@"list"] copy];
        [self.tblMisServicios reloadData];
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
