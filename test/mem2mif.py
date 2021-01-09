import sys

MAX_MEMSIZE = 256 * 1024
MAX_MEMSIZE_WORD = int(MAX_MEMSIZE / 4)

if __name__ == '__main__':
    if len(sys.argv) != 2:
        sys.stderr.write("[mem2mif.py]\n")
        sys.stderr.write("This is convert script for .mem file to .mif\n")
        sys.stderr.write("format : %s [memfile]\n" % sys.argv[0])
        sys.exit(-1)
    
    filename = sys.argv[1]
    mem = ""

    with open(filename, "r") as f:
        mem = f.read()

    outlines = []
    cnt = 0
    for line in mem.splitlines():
        outlines.append("%d : %s;" % (cnt, line))
        cnt += 1


    print("WIDTH=32;")
    print("DEPTH=%d;" % MAX_MEMSIZE_WORD)
    print("ADDRESS_RADIX=UNS;")
    print("DATA_RADIX=HEX;")
    print("CONTENT BEGIN")
    
    for line in outlines:
        print("\t%s" % line)
    
    #print("\t[%d..%d] : 00000000;" % (cnt + 1, MAX_MEMSIZE_WORD - 1))
    print("END;")