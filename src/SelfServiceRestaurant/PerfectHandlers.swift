//
//  PerfectHandlers.swift
//  SelfServiceRestaurant
//
//  Created by Kamil Czopek on 22/06/16.
//  Copyright © 2016 Kamil Czopek. All rights reserved.
//

import PerfectLib

// This function is required. The Perfect framework expects to find this function
// to do initialization
public func PerfectServerModuleInit() {
    
    PageHandlerRegistry.addPageHandler("CategoriesListJSONHandler") {
        (r:WebResponse) -> PageHandler in
        
        return CategoriesListJSONHandler()
    }
    
    PageHandlerRegistry.addPageHandler("ProductsInCategoryJSONHandler") {
        (r:WebResponse) -> PageHandler in
        
        return ProductsInCategoryJSONHandler()
    }

    PageHandlerRegistry.addPageHandler("IndexHandler") {
        (r:WebResponse) -> PageHandler in
        
        return IndexHandler()
    }
    
    PageHandlerRegistry.addPageHandler("CategoryHandler") {
        (r:WebResponse) -> PageHandler in
        
        return CategoryHandler()
    }
    
    PageHandlerRegistry.addPageHandler("CartHandler") {
        (r:WebResponse) -> PageHandler in
        
        return CartHandler()
    }
    
    PageHandlerRegistry.addPageHandler("CheckoutHandler") {
        (r:WebResponse) -> PageHandler in
        
        return CheckoutHandler()
    }
    
    PageHandlerRegistry.addPageHandler("ConfirmationHandler") {
        (r:WebResponse) -> PageHandler in
        
        return ConfirmationHandler()
    }
    
    PageHandlerRegistry.addPageHandler("CatName") {
        // This closure is called in order to create the handler object.
        // It is called once for each relevant request.
        // The supplied WebResponse object can be used to tailor the return value.
        // However, all request processing should take place in the `valuesForResponse` function.
        (r:WebResponse) -> PageHandler in
        return CatNameHandler()
    }
    
    PageHandlerRegistry.addPageHandler("FullFoodList") {
        (r:WebResponse) -> PageHandler in
        
        return FoodListHandler()
    }
    
    PageHandlerRegistry.addPageHandler("AllProductsList") {
        (r:WebResponse) -> PageHandler in
        
        return ProductListHandler()
    }

}
