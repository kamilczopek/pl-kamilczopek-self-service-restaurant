//
//  ProductsInCategoryJSONHandler.swift
//  SelfServiceRestaurant
//
//  Created by Kamil Czopek on 29/06/16.
//  Copyright © 2016 Kamil Czopek. All rights reserved.
//

import PerfectLib
import PostgreSQL


class ProductsInCategoryJSONHandler: PageHandler {
    lazy var dbHost:String = self.getEnvVar("DATABASE_HOST")
    lazy var dbName:String = self.getEnvVar("DATABASE_NAME")
    lazy var dbUsername:String = self.getEnvVar("DATABASE_USER")
    lazy var dbPassword:String = self.getEnvVar("DATABASE_PASS")
    
    func valuesForResponse(context: MustacheEvaluationContext, collector: MustacheEvaluationOutputCollector) throws -> MustacheEvaluationContext.MapType {
        
        context.webRequest?.postBodyString
        
        
        let params = context.webRequest?.params()
        
        var selectedCategory = "" // default category type
        if (params?.count > 0) {
            for (name, value) in params! {
                if (name == "selectedCategory") {
                    selectedCategory = value
                }
            }
        }
        
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
        let queryResult : PGResult
        if (selectedCategory == "") {
            queryResult = pgsl.exec("SELECT product.id, product.name, product.price, product.description, product.image_name FROM product, category WHERE category.id = product.category_id ORDER BY product.id;")
        }
        else {
            queryResult = pgsl.exec("SELECT product.id, product.name, product.price, product.description, product.image_name FROM product, category WHERE category.id = product.category_id AND category.name = $1 ORDER BY product.id;", params: [selectedCategory])
        }
        
        
        
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
                print("field name: " + fieldName)
                switch fieldName {
                case "id":
                    parameter["id"] = queryResult.getFieldString(indexOfRow, fieldIndex: indexOfField)
                case "name":
                    parameter["name"] = queryResult.getFieldString(indexOfRow, fieldIndex: indexOfField)
                case "price":
                    parameter["price"] = queryResult.getFieldString(indexOfRow, fieldIndex: indexOfField)
                case "description":
                    parameter["description"] = queryResult.getFieldString(indexOfRow, fieldIndex: indexOfField)
                case "image_name":
                    parameter["image_name"] = queryResult.getFieldString(indexOfRow, fieldIndex: indexOfField)
                default: break
                }
            }
            
            //last row does not need comma, so we're setting flag
            if indexOfRow == numberOfRows-1 {
                parameter["last"] = true
            }
            
            parameters.append(parameter)
        }
        
        let dict:MustacheEvaluationContext.MapType = ["whole list":parameters]
        return dict
    }
    
    private func getEnvVar(name: String) -> String {
        return String.fromCString(getenv(name)) ?? ""
    }
    
}

