import sys
import argparse
from collections import OrderedDict
import requests
from statistics import mean

parser = argparse.ArgumentParser(description='Get data from Prometheus Server')

# input parser
def getArguments():
    parser.add_argument('-s', '--start',
                        action='store',
                        type=str,
                        )
    parser.add_argument('-e', '--end',
                        action='store',
                        type=str,
                        )
    parser.add_argument('-q', '--query',
                        action='store',
                        type=str,
                        )
    args = parser.parse_args()
    return args

def main():
    args = getArguments()
    params = OrderedDict([('query', args.query), ('start', args.start[0:10]), ('end', args.end[0:10]), ('step', '1')])
    # print(params)

    response = requests.get('http://deep.ics.uci.edu:9090/api/v1/query_range', params=params)
    results = response.json()['data']['result']
    df_value = []
    for result in results:
        df_value.extend( [float(value[1]) for value in results[0]['values']] )
    print(mean(df_value))

if __name__ == "__main__":
    main()