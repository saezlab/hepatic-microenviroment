library(ggplot2)
library(cowplot)

theme_set(theme_cowplot())

my_theme = function(grid = NULL) {
  
  if (is.null(grid)) {
    p = background_grid(major = "xy", minor = "none", size.major = 0.4) 
  } else if (grid == "y") {
    p = background_grid(major = "y", minor = "none", size.major = 0.4) 
  } else if (grid == "x") {
    p = background_grid(major = "x", minor = "none", size.major = 0.4) 
  } else if (grid == "no") {
    p = theme()
  }
  p = p + 
    theme(title = element_text(size=12),
          axis.text = element_text(size=11),
          legend.text = element_text(size=11),
          strip.background = element_rect(colour = "white", fill="white"),
          strip.text.x  = element_text(size=12)
    )
}
