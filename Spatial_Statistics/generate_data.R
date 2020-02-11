# Generate mock survey responses
num.surveys = 30
num.locs = 5
num.rows = num.surveys * num.locs * 3

# initialize data frame of responses called survey_data 
survey_data = data.frame(matrix(0, nrow = num.rows, ncol = 4))
colnames(survey_data) = c("id", "location", "safety", "circumstance")
survey_data$location = rep(1:num.locs, num.surveys)

ids = rep(1, num.locs)
for(j in 2:num.surveys){
  ids = c(ids, rep(j, num.locs))
}
survey_data$id = ids

survey_data$circumstance = c(rep("today", num.surveys*num.locs),
                           rep("alone", num.surveys*num.locs),
                           rep("night", num.surveys*num.locs))

overall.means = runif(num.surveys, 2, 8)

for(i in 1:num.surveys){
  df.i = survey_data[survey_data$id == i,]
  df.i[df.i$circumstance == "today",] = overall.means[i] + rnorm(num.locs)
  df.i[df.i$circumstance == "alone",] = overall.means[i] - 1 + rnorm(num.locs)
  df.i[df.i$circumstance == "night",] = overall.means[i] - 2 + rnorm(num.locs)
  survey_data[survey_data$id == i,]$safety = df.i$safety
}

survey_data$safety = ifelse(survey_data$safety > 0, survey_data$safety, 0)

write.csv(survey_data, "survey_data.csv", row.names = FALSE)
