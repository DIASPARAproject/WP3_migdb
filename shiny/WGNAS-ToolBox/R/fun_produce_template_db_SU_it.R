#' fun_produce_template_db_SU_it create excel template
#' @param sub
#' @param SU_id
#' @param template
#' @param i
#' @param blank_y
#' @return Nothing
fun_produce_template_db_SU_it <- function(sub, SU_id, template, i, blank_y) {
    var_data_area <- subset(sub, sub$var_mod == i)[, c(
        "year", "type", "age", "area",
        "location", "metric", "value",
        "var_mod"
    )]

    if (i != "omega" &
        grepl("_pr", i) == F &
        grepl("p_C", i) == F &
        grepl("deltat", i) == F &
        grepl("min", i) == F &
        grepl("max", i) == F &
        grepl("CV_theta1", i) == F) {
        n_insert <- length(which(var_data_area$year == blank_y))

        for (loc in 1:n_insert) {
            loc_insert <- which(var_data_area$year == blank_y)[loc]
            pattern_insert <- var_data_area[loc_insert, ]

            var_data_area <- dplyr::add_row(
                var_data_area,
                year = pattern_insert$year + 1,
                type = pattern_insert$type,
                age = pattern_insert$age,
                location = pattern_insert$location,
                metric = pattern_insert$metric,
                value = NA,
                var_mod = pattern_insert$var_mod,
                .after = loc_insert
            )
        }

        j <- length(sheets(template)) + 1

        addWorksheet(wb = template, sheetName = i)
        writeData(template, sheet = j, var_data_area, startRow = 1, startCol = 1, colNames = TRUE, rowNames = F)
        fillStyle <- createStyle(
            fontSize = 12, fontColour = "black",
            halign = "center", valign = "center", fgFill = "mistyrose",
            border = "TopBottomLeftRight", borderColour = "black",
            textDecoration = "bold", wrapText = TRUE
        )
        BlankStyle <- createStyle(
            fontColour = "red",
            valign = "center", fgFill = "mistyrose", borderColour = "red",
            textDecoration = "bold"
        )
        headerStyle <- createStyle(
            fontSize = 12, fontColour = "black",
            halign = "center", valign = "center", fgFill = "grey",
            border = "TopBottomLeftRight", borderColour = "black",
            textDecoration = "bold", wrapText = TRUE
        )
        addStyle(template,
            sheet = j, fillStyle, rows = 1:nrow(var_data_area), cols = 7,
            gridExpand = TRUE
        )
        addStyle(template,
            sheet = j, headerStyle, rows = 1, cols = 1:8,
            gridExpand = TRUE
        )
        addStyle(template,
            sheet = j, BlankStyle, rows = which(is.na(var_data_area$value)) + 1, cols = 1:8,
            gridExpand = TRUE
        )
    }
}
