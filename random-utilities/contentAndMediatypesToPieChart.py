#!/usr/bin/env python
# -*- coding: utf-8 -*

import numpy as np
import matplotlib.pyplot as plt
import operator

'''
The script takes a list of content and media type -combinations and plot them into
a pie chart.
'''

inputFile = '/home/tuomo/Työpöytä/PIKIn_analyysit/data/KAIKKI/336ja337_formatted.txt'

def formatData(data):
    '''
    Return two lists for plotting, "labels" and "sizes". Length of the lists is 5.
    E.g.
    ["Label 1", "label 2", "label 3", "label 4", "the rest"]
    [20.5, 12.5 ...]
    '''
    labels = []
    sizes = [0, 0, 0, 0, 0]
    dataDict = {}
    for line in data:
        try:
            count, content, media = line.split('\t')
        except:
            content = ''
            media = ''
        dataDict[content + " - " + media] = int(count)
    sorted_data = sorted(dataDict.items(), key=operator.itemgetter(1), reverse=True)
    for i, item in enumerate(sorted_data):
        if i < 4:
            labels.append(item[0].decode('utf-8'))
            sizes[i] += int(item[1])
    labels.append("Muut")
    sizes[-1] = sum(dataDict.values()) - sum(sizes)
    return labels, sizes

def plotData(labels, sizes):
    #cmap = plt.cm.prism
    #colors = cmap(np.linspace(0., 1., len(labels)))
    colors = ['gold', 'yellowgreen', 'lightcoral', 'lightskyblue', 'red']
    explode = (0.01, 0.05, 0.05, 0.05, 0.05)
    plt.pie(sizes, labels=labels, colors=colors, autopct='%1.1f%%', shadow=True, explode=explode, startangle=49, labeldistance=1.05)
    plt.axis('equal')
    plt.title(u'Pikin aineistolajit (sisältö- ja mediatyypit)', bbox={'facecolor':'0.9', 'pad':5})
    plt.show()


with open(inputFile, 'r') as f:
    data = f.read().strip().split('\n')

labels, sizes = formatData(data)
plotData(labels, sizes)