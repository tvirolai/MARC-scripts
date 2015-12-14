#!/usr/bin/env python
# -*- coding: utf-8 -*

import numpy as np
import matplotlib.pyplot as plt
import operator

'''
The script takes a list of language and their counts and plots them to a pie chart.
'''

inputFile = '/home/tuomo/Työpöytä/PIKIn_analyysit/data/KAIKKI/raportit/kielet008.tsv'

def formatData(data):
    '''
    Return two lists for plotting, "labels" and "sizes". Length of the lists is 10.
    E.g.
    ["Label 1", "label 2", "label 3", "label 4", "the rest"]
    [20.5, 12.5 ...]
    '''
    labels = []
    sizes = list(np.zeros((11,), dtype=np.int))
    
    for i, line in enumerate(data):
        count, language = line.split('\t')
        if i < 10:
            labels.append(language.decode('utf-8'))
            sizes[i] = int(count)
            print(language, count)
        else:
            sizes[-1] += int(count)
    labels.append("muut")
    return labels, sizes

def percentage(amount, total):
    return round(amount / float(total) * 100, 1)

def plotData(labels, sizes):
    #cmap = plt.cm.prism
    #colors = cmap(np.linspace(0., 1., len(labels)))
    colors = ['yellowgreen','red','gold','lightskyblue','white','lightcoral','blue','pink', 'darkgreen','yellow', 'cyan']
    plt.pie(sizes,  colors=colors, shadow=True, startangle=49, labeldistance=1.05)
    plt.axis('equal')
    plt.title(u'Yleisimmät kielet Pikin aineistossa', bbox={'facecolor':'0.9', 'pad':5})
    patches, texts = plt.pie(sizes, colors=colors, startangle=90)
    labelsWithPercentages = [x + " (" + str(percentage(sizes[i], sum(sizes))) + " %)" for i, x in enumerate(labels)]
    plt.legend(patches, labelsWithPercentages, loc="best")
    plt.savefig('/home/tuomo/Työpöytä/PIKIn_analyysit/Graafit/kielet_KAIKKI_tiivis.png', bbox_inches='tight')
    plt.show()


with open(inputFile, 'r') as f:
    data = f.read().strip().split('\n')

labels, sizes = formatData(data)
plotData(labels, sizes)