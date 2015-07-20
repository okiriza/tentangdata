### Copyright Okiriza Wibisono & Ali Akbar S.
### July 2015


library(shiny)

shinyUI(fluidPage(
    titlePanel('Linear Regression Simulation'),

    sidebarLayout(
        sidebarPanel(
            tags$div(
                numericInput('num_mean', 'Mean', value = 0, step = 0.01),
                numericInput('num_sd', 'Standard deviation', value = 1.0, step = 0.01),
                style = 'width: 200px'
            ),

            sliderInput('num_randomness', 'Randomness', value = 20, min = 0, max = 100),
            sliderInput('sld_num_data', 'Number of data points', min = 2, max = 100, value = 50),

            actionButton('btn_generate', 'Generate new data', style='background-color: steelblue; color: white'),

            shiny::hr(),

            radioButtons('rad_show_line', 'Line to show', selected = 'draw', choices = list(
                'None' = 'none',
                'Draw (try clicking on the plot)' = 'draw',
                'Least squares fit' = 'lse',
                'Both' = 'both'
            )),
            checkboxInput('chk_show_errors', 'Show deviations?', value=FALSE)
        ),

        mainPanel(
            h3("Results"),

            fluidRow(
                column(2,
                       h4("Coefficients"),
                       h5(em(a("Intercept", href = "https://en.wikipedia.org/wiki/Y-intercept"))),
                       h5(em(a("Slope", href = "https://en.wikipedia.org/wiki/Slope")))
                ),

                column(2,
                       h4("Your line", style = "color: blue; text-decoration: underline"),
                       h5(strong(textOutput("user_intercept"))),
                       h5(strong(textOutput("user_slope")))
                ),

                column(2,
                       h4("LSE line", style = "color: green; text-decoration: underline"),
                       h5(textOutput("lse_intercept")),
                       h5(textOutput("lse_slope"))
                ),

                column(2,
                    h4("Eval Metrics"),
                    h5(em(a("RMSE", href = "https://en.wikipedia.org/wiki/Root-mean-square_deviation"))),
                    h5(em("RSE")),
                    h5(em(a("MAE", href = "https://en.wikipedia.org/wiki/Mean_absolute_error"))),
                    h5(em(a("R-squared", href = "https://en.wikipedia.org/wiki/Coefficient_of_determination")))
                ),

                column(2,
                    h4("Your line", style = "color: blue; text-decoration: underline"),
                    h5(strong(textOutput("user_RMSE"))),
                    h5(strong(textOutput("user_RSE"))),
                    h5(strong(textOutput("user_MAE"))),
                    h5(strong(textOutput("user_R2")))
                ),

                column(2,
                    h4("LSE line", style = "color: green; text-decoration: underline"),
                    h5(textOutput("lse_RMSE")),
                    h5(textOutput("lse_RSE")),
                    h5(textOutput("lse_MAE")),
                    h5(textOutput("lse_R2"))
                )
            ),

            plotOutput('plot', click = 'plot_click')
        )
    )
))
