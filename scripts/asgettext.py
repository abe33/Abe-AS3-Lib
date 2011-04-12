import sys
import getopt
import re

_debug = 0

def usage():
	print """The asgettext.py script generates a *.fil file with the path of all the actionscript classes compiled in a *.swf file. 
The asgettext.py script takes a XML file resulting of the use of the -link-report compiler options when compiling a flash file.
The generated *.fil file can then be used with the xgettext utility to generates the corresponding *.po file.

Usage :

python asgettext.py [OPTIONS] XML_REPORT

Options : 

-o, --output	Specify the path for the generated *.fil file, by default the output is tmp.fil
-h, --help	Display this message
-d		Activate debug messages
"""

def main(argv):
	output = "tmp.fil"                        
	try:                                
		opts, args = getopt.getopt(argv, "ho:d", ["help", "output="])
	except getopt.GetoptError:
		usage()
		sys.exit(2)     

	for opt, arg in opts:               
		if opt in ("-h", "--help"):      
			usage()                     
			sys.exit()                  
		elif opt == '-d':                
			global _debug               
			_debug = 1                  
		elif opt in ("-o", "--output"): 
			output = arg               

	source = "".join(args)  
	
	if source == "" :
		usage()
		sys.exit(2) 
	
	f = open(source, 'r')
	content = f.read()
	
	# we only needs paths to *.as files, and not *.swc 
	# nor path to embed assets which don't have an absolute path
	r = re.compile( 'name="((/|[\w]{1}://)[^"]+.as)"' )
	res = r.findall( content )
	
	output_string = "\n".join([ o[0] for o in res ])
	
	if _debug == 1:
		print output_string
	
	f2 = open( output, 'w' )
	f2.write( output_string )

if __name__ == "__main__":
    main(sys.argv[1:])
