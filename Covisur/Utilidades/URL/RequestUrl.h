//
//  RequestUrl.h
//  Tomapp
//
//  Created by Christian Fernandez on 20/12/16.
//  Copyright © 2016 Sainet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestUrl : NSObject

+(NSString *)obtenerToken;

+(NSMutableDictionary *)login:(NSMutableDictionary *)datos;

+(NSMutableDictionary *)variablesGlobales;

+(NSMutableDictionary *)variablesGlobales:(NSMutableDictionary *)datos;

+(NSMutableDictionary *)tiposDocumentos;

+(NSMutableDictionary *)codigoContrasena:(NSMutableDictionary *)datos;

+(NSMutableDictionary *)crearUsuario:(NSMutableDictionary *)datos;

+(NSMutableDictionary *)obtenerListadoServiciosActivos:(NSMutableDictionary *)datos;

+(NSMutableDictionary *)enviarCodigoGenerado:(NSString *)datos;

+(NSMutableDictionary *)actualizarContrasena:(NSString *)datos andUid:(NSString *)uid;

+(NSMutableDictionary *)actualizarCuenta:(NSMutableDictionary *)datos;

+(NSMutableDictionary *)miCuenta:(NSString *)idUsuario;

+(NSMutableDictionary *)enviarDatosInvestigado:(NSMutableDictionary *)datos;

+(NSMutableDictionary *)serviciosPagos;

+(NSMutableDictionary *)reservar:(NSMutableDictionary *)datos;

+(NSMutableDictionary *)borrarReserva:(NSString *)idReserva;

+(NSMutableDictionary *)crearPago:(NSMutableDictionary *)dataEnvio;

+(NSMutableDictionary *)serviciosGratuitos;

+(NSMutableDictionary *)eliminarUsuario:(NSString *)datos uid:(NSString *)andUid;

+(NSMutableDictionary *)MisServiciosPagos:(NSString *)uid;

+(NSMutableDictionary *)obtenerTarjetasCredito:(NSString *)uid;

+(NSMutableDictionary *)borrarTarjetasCredito:(NSString *)uid;

+(NSMutableDictionary *)crearTarjetasCredito:(NSMutableDictionary *)datos;

+(NSMutableDictionary *)actualizarTarjetaCredito:(NSMutableDictionary *)datos;

+(NSMutableDictionary *)obtenerTerminosCondiciones;

+(NSMutableDictionary *)obtenerCiudades;

@end
