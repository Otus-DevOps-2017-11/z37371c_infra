#!/bin/python

import sys
import json

if len(sys.argv) == 2 and (sys.argv[1] == '--list'):
    inventory=open('inventory.json','r')
    print json.dumps(json.load(inventory), indent=4)
    inventory.close()
elif len(sys.argv) == 3 and (sys.argv[1] == '--host'):
    print '{}'
else:
    print "Usage: %s --list or --host <hostname>" % sys.argv[0]
    sys.exit(1)
