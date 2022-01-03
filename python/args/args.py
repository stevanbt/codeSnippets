import argparse

def argParser() :

    ap = argparse.ArgumentParser()
    ap.add_argument("-p", "--proxyDir", required=True,
        help="Directory containing the source images (these can be proxies of full size images)")
    ap.add_argument("-d", "--sourceDir", required=False,
        help="Directory containing the full size images (this can be the same location as the proxies if you're not using proxies)")
    ap.add_argument("-s", "--sampleSize", required=False, default=0, type=int,
        help="Sample size")
    ap.add_argument("-e", "--fileExtension", required=False, default="jpg",
        help="The file extension of the images to be processed")
    ap.add_argument("-m", "--mode", required=False, default="live",
        help="Mode that this program will run in, defaults to 'live' which will call AWS.  Anything else will NOT call AWS and will create test tags.")
    ap.add_argument("-c", "--confidence", default="90", type=float,
        help="Minimum confidence percentage for retrieved bib numbers")
    ap.add_argument("-l", "--loggingLevel", default="INFO", required=False,
        help="Logging level.  Values can be one of the following: 'DEBUG, INFO, WARNING, ERROR, CRITICAL'")
    args = vars(ap.parse_args())

    return args

def main():

    args = argParser()



if __name__ == "__main__":
    main()