import os

def process(ucf_path):
    with open(ucf_path) as f:
        ucf = f.readlines()
    xdc = []
    for line in ucf:
        if not '|' in line:
            continue
        else:
            tmppos = line.find('"')
            net = line[tmppos+1: line.find('"', tmppos+1)]
            loc = line[line.find('LOC=')+4: line.find('|')].strip()
            iostandard = line[line.find('IOSTANDARD=')+11 : line.find(';')]
            xdc.append(f'set_property LOC {loc} [get_ports {net}]\n')
            xdc.append(f'set_property IOSTANDARD {iostandard} [get_ports {net}]\n')
    with open('output.xdc', 'w') as f:
        f.writelines(xdc)


if __name__ == "__main__":
    import sys
    if(len(sys.argv) < 2):
        print("Please give ucf file!!")
    else:
        process(sys.argv[1])