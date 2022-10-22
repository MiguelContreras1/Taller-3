## MODELO LASSO

library("dplyr") 
library("caret")

set.seed(123)
lambda <- 10^seq(-2, 3, length = 100)

lasso <- train(modelo1, 
               data = train, 
               method = "glmnet",
               trControl = trainControl("cv", number = 5),
               tuneGrid = expand.grid(alpha = 1, lambda=lambda), 
               preProcess = c("center", "scale")
)

lasso

test$lasso <- predict(lasso,newdata = test)
with(test,mean((price-lasso)^2))

# regularización lasso

regula_lasso <- lasso$beta %>% 
  as.matrix() %>%
  t() %>% 
  as_tibble() %>%
  mutate(lambda = lasso$lambda)

regula_lasso <- regula_lasso %>%
  pivot_longer(
    cols = !lambda, 
    names_to = "predictor",
    values_to = "coeficientes"
  )

regula_lasso %>%
  ggplot(aes(x = lambda, y = coeficientes, color = predictor)) +
  geom_line() +
  scale_x_log10(
    breaks = scales::trans_breaks("log10", function(x) 10^x),
    labels = scales::trans_format("log10",
                                  scales::math_format(10^.x))
  ) +
  labs(title = "Coeficientes del modelo en función de la regularización (Lasso)", x = "Lambda", y = "Coeficientes") +
  theme_bw() +
  theme(legend.position="bottom")






