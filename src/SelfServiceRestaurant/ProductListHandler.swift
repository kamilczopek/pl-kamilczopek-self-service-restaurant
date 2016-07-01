//
//  ProductListHandler.swift
//  SelfServiceRestaurant
//
//  Created by Kamil Czopek on 24/06/16.
//  Copyright © 2016 Kamil Czopek. All rights reserved.
//

import PerfectLib
import PostgreSQL
#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

class ProductListHandler: PageHandler {
    lazy var dbHost:String = self.getEnvVar("DATABASE_HOST")
    lazy var dbName:String = self.getEnvVar("DATABASE_NAME")
    lazy var dbUsername:String = self.getEnvVar("DATABASE_USER")
    lazy var dbPassword:String = self.getEnvVar("DATABASE_PASS")
    
    func valuesForResponse(context: MustacheEvaluationContext, collector: MustacheEvaluationOutputCollector) throws -> MustacheEvaluationContext.MapType {
        
        //open postgre db
        let pgsl = PostgreSQL.PGConnection()
        
        pgsl.connectdb("host='\(dbHost)' dbname='\(dbName)' user='\(dbUsername)' password='\(dbPassword)'")
        
        defer {
            pgsl.close()
        }
        
        guard pgsl.status() != .Bad else {
            throw PerfectError.FileError(500, "Internal Server Error - failed to connect to db")
        }
        
        //execute query
        let queryResult = pgsl.exec("SELECT product.name as product_name, category.name as category_name FROM product, category WHERE category.id = product.category_id;")
        
        guard queryResult.status() == .CommandOK || queryResult.status() == .TuplesOK else {
            throw PerfectError.FileError(500, "Internal Server Error - db query error")
        }
        
        guard case let numberOfFields = queryResult.numFields() where numberOfFields != 0 else {
            throw PerfectError.FileError(500, "Internal Server Error - db returned nothing")
        }
        
        guard case let numberOfRows = queryResult.numTuples() where numberOfRows != 0 else {
            throw PerfectError.FileError(204, "Internal Server Error - query returned empty result")
        }
        
        //parse from db names and types to something we want to work with
        var parameters: [[String:Any]] = []
        0.stride(to: numberOfRows, by: 1).forEach { indexOfRow in
            var parameter = [String:Any]()
            
            0.stride(to: numberOfFields, by: 1).forEach { indexOfField in
                guard let fieldName = queryResult.fieldName(indexOfField) else {
                    return
                }
                
                
                print(fieldName + ": " + queryResult.getFieldString(indexOfRow, fieldIndex: indexOfField))
                
                switch fieldName {
                case "product_name":
                    parameter["productName"] = queryResult.getFieldString(indexOfRow, fieldIndex: indexOfField)
                case "category_name":
                    parameter["productCategory"] = queryResult.getFieldString(indexOfRow, fieldIndex: indexOfField)
                case "with_glutein":
                    parameter["contains glutein"] = queryResult.getFieldBool(indexOfRow, fieldIndex: indexOfField)
                case "price":
                    parameter["price"] = queryResult.getFieldInt(indexOfRow, fieldIndex: indexOfField)
                default: break
                }
            }
            
            parameters.append(parameter)
        }
        
        //and wrap this into MustacheEvaluationContext.MapType with approreate key
        let dict: MustacheEvaluationContext.MapType = ["params":parameters,
                                                       "title":"Whatever title you want",
                                                       "header":"Please find the following products: "]
        
        return dict
    }
    
    private func getEnvVar(name: String) -> String {
        return String.fromCString(getenv(name)) ?? ""
    }
}
