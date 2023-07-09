library("dplyr")

# create a data frame
emp_data <- data.frame(
   emp_id = c(1:5),
   emp_name = c("Rick", "Dan", "Michelle", "Ryan", "Gary"),
   salary = c(623.3, 515.2, 611.0, 729.0, 843.25),
   start_date = as.Date(
        c(
            "2012-01-01",
            "2013-09-23",
            "2014-11-15",
            "2014-05-11",
            "2015-03-27"
        )
    ),
   stringsAsFactors = FALSE
)

# filter
emp_data %>% filter(emp_name == 'Rick')

# apply a function to a column and filter
emp_data %>%
   mutate(emp_name, new_salary = salary * 3) %>%
   filter(grepl("ick", emp_name))
