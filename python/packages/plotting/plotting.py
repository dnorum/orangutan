import pandas
from plotnine import *
import numpy
import matplotlib.pyplot as plt

def data_to_data_frame(data, labels):
    result = pandas.DataFrame(data=data, columns=labels, copy=True)
    return result

def create_plot(data, columns):
    dataframe = data_to_data_frame(data=data, labels=columns)
    plot = (ggplot(dataframe, aes(x="width", y="height", fill="thickness"))
            + geom_tile(aes(width=.0625, height=.0625)))
    return plot





# Eclipse scrollbar...