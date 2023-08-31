from plotnine import ggplot, aes, geom_tile
from .conversion import data_to_data_frame

def create_plot(data, columns):
    dataframe = data_to_data_frame(data=data, labels=columns)
    plot = (ggplot(dataframe, aes(x="width", y="height", fill="thickness"))
            + geom_tile(aes(width=.0625, height=.0625)))
    return plot
# 1
# 2
# 3
# 4
# 5
# Eclipse scrollbar...