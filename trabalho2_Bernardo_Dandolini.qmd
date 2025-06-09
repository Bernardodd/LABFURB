# INSTALAR OS PACOTES NECESSÁRIOS (SE AINDA NÃO INSTALOU)
# install.packages("GetBCBData")
# install.packages(c("tidyverse", "gganimate", "gifski"))

# CARREGAR AS BIBLIOTECAS
library(GetBCBData)
library(tidyverse)
library(gganimate)

# DEFINIR A SÉRIE: JUROS BRASIL (Selic Meta)
my.id <- c(juros_brasil = 4189)

# DOWNLOAD DA SÉRIE
df.bcb <- gbcbd_get_series(
  id = my.id,
  first.date = '2000-01-01',
  last.date = Sys.Date(),
  format.data = 'long',
  use.memoise = TRUE,
  cache.path = tempdir(),
  do.parallel = FALSE
)

# INSPECIONAR OS DADOS
glimpse(df.bcb)

# GRÁFICO ANIMADO COM PONTOS E VALORES
p <- ggplot(df.bcb, aes(x = ref.date, y = value)) +
  geom_line(color = "black") +
  geom_point(color = "red", size = 2) +
  geom_text(aes(label = round(value, 2)), vjust = -1.2, size = 3, check_overlap = TRUE) +
  labs(
    title = "Evolução da Taxa Selic Meta (juros_brasil)",
    subtitle = "Data: {frame_time}",
    x = "Data",
    y = "Taxa de Juros (% a.a.)",
    caption = "Fonte: Banco Central do Brasil via GetBCBData"
  ) +
  transition_reveal(ref.date) +
  theme_minimal()

# EXIBIR A ANIMAÇÃO
animate(p, width = 900, height = 500, fps = 20, duration = 12, renderer = gifski_renderer())
