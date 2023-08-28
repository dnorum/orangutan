import pandas
from plotnine import *
import scipy
import numpy
import matplotlib.pyplot as plt

def data_to_data_frame(data, labels):
    print(labels)
    result = pandas.DataFrame(data=data, columns=labels, copy=True)
    return result

def create_plot(data):
    plot = (ggplot(data, aes(x="width", y="height", fill="thickness"))
            + geom_tile(aes(width=.01625, height=.01625)))
    print(plot)
    return plot

def create_interpolated_plot(data):
    points = []
    values = []
    x_min = 0
    x_max = 0
    y_min = 0
    y_max = 0
    for record in data:
        x = record[0]
        y = record[1]
        if x < x_min:
            x_min = x
        if x > x_max:
            x_max = x
        if y < y_min:
            y_min = y
        if y > y_max:
            y_max = y
        points.append([x, y])
        values.append(record[2])
    interp = scipy.interpolate.LinearNDInterpolator(points, values)
    X = numpy.linspace(x_min, x_max)
    Y = numpy.linspace(y_min, y_max)
    X, Y = numpy.meshgrid(X, Y)
    Z = interp(X, Y)
    #plot = (ggplot(data, aes(x="width", y="height", fill="thickness"))
    #        + geom_tile(aes(width=.01625, height=.01625)))
    #print(plot)
    plt.pcolormesh(X, Y, Z, shading='auto')
    plt.colorbar()
    plt.show()
    return plot





# Eclipse scrollbar...