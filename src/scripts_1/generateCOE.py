import cv2
import numpy as np
import matplotlib.pyplot as plt
import json
import os.path as osp
import sys

def colorMap(rgb):
    retstr = ''
    for co in rgb:
        curco = co
        if(curco == 255):
            curco = 0
        retstr += hex(int(curco / 256 * 16))[2:][0].upper()
    return retstr
def getCOE(img):
    ret = []
    for x in range(img.shape[0]):
        for y in range(img.shape[1]):
            ret.append(colorMap(img[x][y]))
    return ret

def process(configPath):
    with open(configPath) as f:
        configs = json.load(f)
    addr_map = {}
    lines = []
    coes = []

    for image_dict in configs['images']:
        img_path = osp.join(configs['image_dir'], image_dict['name'])
        img = cv2.imread(img_path)
        img = cv2.resize(img, (image_dict['width'], image_dict['height']))
        image_dict['addr'] = len(coes)
        coes.extend(getCOE(img))


    lines.append('memory_initialization_radix=16;\n')
    lines.append('memory_initialization_vector=' + ','.join(coes) + ';')

    with open(configs['coe_dir'], 'w') as f:
        f.writelines(lines)

    with open(configs['map_dir'], 'w') as f:
        json.dump(configs, f)

if __name__ == '__main__':
    if(len(sys.argv) < 2):
        raise FileNotFoundError("You must include a config file!")
    print("Processing using " + sys.argv[1])
    process(sys.argv[1])
