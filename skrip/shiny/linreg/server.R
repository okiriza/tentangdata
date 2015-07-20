### Copyright Okiriza Wibisono & Ali Akbar S.
### July 2015


library(shiny)
library(ggplot2)

source('helpers.R')

user_col = 'blue'
lse_col = 'green'
line_cols = c('Your line' = user_col, 'LSE line' = lse_col)

shinyServer(function(input, output, session) {
    clicks = reactiveValues(first = NULL, both = NULL)

    data = eventReactive(input$btn_generate, {
        r = min(max(input$num_randomness, 0), 100)
        updateNumericInput(session, 'num_randomness', value = r)
        data.frame(generate(input$sld_num_data, input$num_mean, input$num_sd, r))
    }, ignoreNULL = FALSE)

    observeEvent(input$plot_click, {
        shown_line = input$rad_show_line
        if (shown_line %in% c('none', 'lse')) {
            clicks$first = NULL
            clicks$both = NULL
        } else {
            if (is.null(clicks$first)) {
                clicks$first = c(input$plot_click$x, input$plot_click$y)
                clicks$both = NULL
            } else {
                clicks$both = list(first = clicks$first, second = c(input$plot_click$x, input$plot_click$y))
                clicks$first = NULL
            }
        }
    })

    observeEvent(input$btn_generate, {
        clicks$first = NULL
        clicks$both = NULL
    })

    a_lse = reactive({
        data_points = data()
        compute_a(data_points$x, data_points$y)
    })

    b_lse = reactive({
        data_points = data()
        compute_b(data_points$x, data_points$y)
    })

    pred_lse = reactive({
        a = a_lse()
        b = b_lse()
        data_points = data()
        a + b*data_points$x
    })

    a_user = reactive({
        clb = clicks$both
        if (!is.null(clb)) {
            b = b_user()
            clb$second[2] - b*clb$second[1]
        }
    })

    b_user = reactive({
        clb = clicks$both
        if (!is.null(clb)) {
            (clb$second[2] - clb$first[2])/(clb$second[1] - clb$first[1])
        }
    })

    pred_user = reactive({
        a = a_user()
        b = b_user()
        data_points = data()
        a + b*data_points$x
    })

    plot_base = reactive({
        data_points = data()
        ggplot(data_points, aes(x, y))
    })

    plot_errors = reactive({
        p = plot_base()
        shown_line = input$rad_show_line

        if (input$chk_show_errors && (shown_line != 'none')) {
            data_points = data()
            n = nrow(data_points)

            if (shown_line == 'draw' || shown_line == 'both') {
                clb = clicks$both
                if (is.null(clb)) {
                    return(p)
                }

                pred = pred_user()
            } else if (shown_line == 'lse') {
                pred = pred_lse()
            }

            p = p + geom_segment(x = data_points$x, y = data_points$y, xend = data_points$x, yend = pred, col = 'red', size = 1)
        }

        p
    })

    plot_points = reactive({
        p = plot_errors()
        p + geom_point(size = 3, shape = 19)
    })

    plot_line = reactive({
        p = plot_points()

        if (input$rad_show_line %in% c('lse', 'both')) {
            p = p + geom_abline(intercept = a_lse(), slope = b_lse(), col = lse_col, size = 1.5)
        }

        clb = clicks$both
        if (!is.null(clb) && (input$rad_show_line %in% c('draw', 'both'))) {
            p = p + geom_abline(intercept = a_user(), slope = b_user(), col = user_col, size = 1.5)
        }

        p
    })

    plot_marks = reactive({
        p = plot_line()
        shown_line = input$rad_show_line

        if (shown_line %in% c('none', 'lse')) {
            return(p)
        }

        clf = clicks$first
        clb = clicks$both

        if (!is.null(clf) || !is.null(clb)) {
            if (!is.null(clf)) {
                x1 = clf[1]
                y1 = clf[2]
            } else {
                x1 = clb$first[1]
                y1 = clb$first[2]
            }

            p = p + geom_point(x = x1, y = y1, shape = 4, size = 5, col = user_col)
        }

        if (!is.null(clb)) {
            p = p + geom_point(x = clb$second[1], y = clb$second[2], shape = 4, size = 5, col = user_col)
        }

        p
    })

    output$plot = renderPlot({plot_marks()})

    output$user_intercept = renderText({
        clb = clicks$both
        if (is.null(clb)) {
            ''
        } else{
            decimal(a_user(), 4)
        }
    })
    output$lse_intercept = renderText({
        decimal(a_lse(), 4)
    })

    output$user_slope = renderText({
        clb = clicks$both
        if (is.null(clb)) {
            ''
        } else{
            decimal(b_user(), 4)
        }
    })
    output$lse_slope = renderText({
        decimal(b_lse(), 4)
    })

    output$user_RMSE = renderText({
        clb = clicks$both
        if (is.null(clb)) {
            ''
        } else{
            decimal(RMSE(data()$y, pred_user()), 4)
        }
    })
    output$lse_RMSE = renderText({
        decimal(RMSE(data()$y, pred_lse()), 4)
    })

    output$user_MAE = renderText({
        clb = clicks$both
        if (is.null(clb)) {
            ''
        } else{
            decimal(MAE(data()$y, pred_user()), 4)
        }
    })
    output$lse_MAE = renderText({
        decimal(MAE(data()$y, pred_lse()), 4)
    })

    output$user_RSE = renderText({
        clb = clicks$both
        if (is.null(clb)) {
            ''
        } else{
            decimal(RSE(data()$y, pred_user()), 4)
        }
    })
    output$lse_RSE = renderText({
        decimal(RSE(data()$y, pred_lse()), 4)
    })

    output$user_R2 = renderText({
        clb = clicks$both
        if (is.null(clb)) {
            ''
        } else{
            decimal(R2(data()$y, pred_user()), 4)
        }
    })
    output$lse_R2 = renderText({
        decimal(R2(data()$y, pred_lse()), 4)
    })

})
