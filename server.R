server <- function(input, output, session) {
    # Input file ----
    df<-reactive({
        inFile<-input$file1
        print(inFile)
        if(is.null(inFile))
            return(NULL)
        dt_frame = read.csv(inFile$datapath, header=input$header, sep=input$sep)
        #updateSelectInput(session, "housingcolumn", choices = list('YrSold','GarageArea','X2ndFlrSF','X1stFlrSF','YearBuilt','OverallCond','OverallQual','LotArea',"SalePrice",'YearBuilt'))
        updateSelectInput(session, "housingcolumnscatx", choices = names(dt_frame))#list('X2ndFlrSFInHundred','X1stFlrSFInHundred','OverallCond','OverallQual','LotAreaInThousand',"GarageAreaInHundreds"))
        updateSelectInput(session, "housingcolumnscaty", choices = names(dt_frame))#list('SalesPriceInThousand'))
        updateSelectInput(session, "housingcolumnplot", choices =  names(dt_frame))
        updateSelectInput(session, "descvar", choices = names(dt_frame))
        return(dt_frame)
        
    })
    
    # Dynamically generate UI input when data is uploaded ----
    output$checkbox <- renderUI({
        checkboxGroupInput(inputId = "select_var", 
                           label = "Select variables to show", 
                           choices = names(df()))
    })
    
    # Select columns to print ----
    df_sel <- reactive({
        req(input$select_var)
        df_sel <- df() %>% select(input$select_var)
    })
    
    # Print data table ----  
    output$rendered_file <- DT::renderDataTable({
        if(input$disp == "head") {
            head(df_sel())
        }
        else {
            df_sel()
        }
    })
    
    #Render histogram ---- 
    # output$hist <- renderPlot({
    #     if(is.null(input$file1))
    #         return(NULL)
    #     dataset<-df()
    #     
    #     hist(dataset[,input$housingcolumn],xlab = input$housingcolumnt
    #          ,ylab = "Value", main = paste("Histogram of " ,input$housingcolumn))
    # })
    
    #Render plot---
    # output$scat <- renderPlot({
    #     if(is.null(input$file1))
    #         return(NULL)
    #     dataset<-df()
    #     plot(dataset[,input$housingcolumnscatx], dataset[,'SalesPriceInThousand'], main = paste("Scatter plot of Sale Price vs " ,input$housingcolumnscatx),
    #          xlab = input$housingcolumnscatx, ylab = 'SalesPriceInThousand',
    #          pch = 19, frame = FALSE, xlim=c(0,100), ylim=c(0,1000))
    #    
    # })
    
    #Render plot ----
    output$plot <- renderPlot({
        if(is.null(input$file1))
            return(NULL)
        dataset<-df()
        #plot(dataset[,input$housingcolumnplot],ylim = c(0,100))
        barplot(table(dataset[,input$housingcolumnplot]))
        
    })
    output$scat <- renderPlot({
        if(is.null(input$file1))
            return(NULL)
        dataset<-df()
        #plot(dataset[,input$housingcolumnplot],ylim = c(0,100))
        ggplot(dataset, aes(as.factor(dataset[,input$housingcolumnscatx]),  dataset[,input$housingcolumnscaty])) + 
            geom_point() + 
            labs(y = dataset[,input$housingcolumnscaty], x = input$housingcolumnscatx);
       
    })
    
    output$describecolumn <- renderPrint({
        dataset <- df()
        print(paste("Description of " ,input$descvar))
        summary <- dataset[,input$descvar]
        print(describe(summary),file = dataset[,input$descvar])
    })
    # TODO
    # Render text ----
    output$describe <- renderText({
        
         'House Price Estimate Calculator, '
         'Please select Dataset'
        
        
    })
    
    output$analysis <- renderText({
        
        'Provide analysis of the project here' })
}
