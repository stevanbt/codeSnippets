import argparse
import os
import logging

def argParser():

    ap = argparse.ArgumentParser()
    ap.add_argument("-f", "--logFileName", default="output.log", required=False, 
        help="Name of the log file.")
    ap.add_argument("-o", "--logOutputDir", default=".", required=False, 
        help="Directory where the log file is to be written.  If not specified the log file will be written to the current directory.")
    ap.add_argument("-l", "--loggingLevel", default="INFO", required=False,
        help="Logging level.  Values can be one of the following: 'DEBUG, INFO, WARNING, ERROR, CRITICAL'")
    args = vars(ap.parse_args())

    return args

def main():

    args = argParser()

    logging.basicConfig(format='%(asctime)s %(levelname)s:%(message)s', filename=os.path.join(args["logOutputDir"], args["logFileName"]), level=args["loggingLevel"])
    logging.info('Started')

    logging.debug("Something to debug")

    logging.info('Finished')

if __name__ == "__main__":
    main()