#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# Set up a consistent path for all chunks of code
knitr::opts_knit$set(root.dir = normalizePath("../../"))
```
#
library(data.table)
library(ggplot2)
library(seqminer)
library(HardyWeinberg)
library(dplyr)
```
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
library(data.table)
freq <- fread("gen_data/02_activities/data/gwa_qc_A1_freq.afreq")  # columns include FID, IID, and SNP genotype
head(freq)
#rs3813199 alt AF is 0.0569126. The ref AF is 0.943087.
#rs11804831 AF is 0.154341. The ref AF is 0.845659.
#rs3128342 AF is 0.304121. The ref AF is 0.694879.
#rs1861 AF is 0.0539859. The ref AF is 0.946014.
#
#
#
#
#
#
#
#
freq <- fread("gen_data/02_activities/data/gwa_qc_A1_maf.afreq")
head(freq)

#rs3813199 MAF is 0.0569126
#rs11804831 MAF is 0.154341
#rs3128342 MAF is 0.304121
#rs1861 MAF is 0.0539859
#
#
#
#
#
#
#
#
#
#
# View HWE results
hwe <- fread("/02_activities/data/gwa_qc_A1_hwe.hardy")
head(hwe)
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# Load genotype data
geno_subset <- fread("/02_activities/data/geno.additive.raw")
geno_subset=geno_subset[!is.na(gene_subset$rs1861_C),]
geno_subset[geno_subset$ID=='rs1861',]
# Fit logistic regression model
model <- glm(PHENOTYPE ~ rs1861_C, data = geno_subset, family = "gaussian")

# View model summary
summary(model)

#The p-value < 2.2e-16

#
#
#
#
#
#
#
#
#
#
#
#
# Create a new data frame containing a sequence of genotype values
 geno_range <- data.frame(
   rs1861_C = seq(0, 2, length.out = 100)
 )
# Use the fitted logistic regression model to predict phenotype probability
# for each genotype value in geno_range
 geno_range$predicted_prob <- predict(model, newdata = geno_range, type = "response")

# Start building the plot
p1=ggplot(geno_subset, aes(x= rs1861_C, y = PHENOTYPE)) +
# Add points showing observed genotype-phenotype combinations
  geom_point() +
  # Add a regression line showing predicted probability across genotype values
  geom_line(# Use the prediction data frame for the line
    data = geno_range,
    aes(x = rs1861_C, y = predicted_prob),
    color = "red",
    # Set line thickness
    size = 1.2
  ) +
  # Control the size range of the points
  scale_size_continuous(range = c(2, 10)) +
  labs(
    title = "Linear Regression: PHENOTYPE ~ Genotype",
    x = "Genotype (0/1/2)",
    y = "Phenotype "
  ) +
   # Apply a minimal theme for a clean appearance
  theme_minimal()

print(p1)
ggsave("/02_activities/data/p1_plot.png", plot = p1, width = 7, height = 5, dpi = 300)
#
#
#
#
#
geno_subset_rec <- geno_subset  # make a copy
geno_subset_rec[, 7:ncol(geno_subset_rec)] <- as.data.frame(
  lapply(geno_subset[, 7:ncol(geno_subset)], function(x) ifelse(x == 2, 1, 0))
)
#
#
#
#
#
model <- glm(PHENOTYPE ~ rs1861_C, data = geno_subset_rec, family = "gaussian")
summary(model)
#The p-value < 2.2e-16
#
#
#
#
#
# Fit logistic regression model
model <- glm(PHENOTYPE ~ rs1861_C, data = geno_subset_rec, family = "gaussian")
summary(model)

geno_range <- data.frame(
   rs1861_C = seq(0, 1, length.out = 100)
 )
 geno_range$predicted_prob <- predict(model, newdata = geno_range, type = "response")

p2=ggplot(geno_subset_rec, aes(x = rs1861_C, y = PHENOTYPE)) +
  geom_point() +
  geom_line(
    data = geno_range,
    aes(x = rs1861_C, y = predicted_prob),
    color = "red",
    size = 1.2
  ) +
  scale_size_continuous(range = c(2, 10)) +
  labs(
    title = "Logistic Regression: PHENOTYPE ~ Genotype",
    x = "Genotype (0/1)",
    y = "Phenotype ") +
  theme_minimal()

print(p2)
ggsave("./02_activities/data/p2_plot.png", plot = p2, width = 7, height = 5, dpi = 300)
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
