import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions
from google.cloud import bigquery
import re, csv
import logging
import sys

PROJECT='msft-sample'
schema = 'company_id:STRING,' \
         'date:DATE,' \
         'open:FLOAT,' \
         'high:FLOAT,' \
         'low:FLOAT,' \
         'close:FLOAT,' \
         'adj_close:FLOAT,' \
         'volume:FLOAT,' \
         'year_val:FLOAT,' \
         'month_val:FLOAT,' \
         'week_val:FLOAT,' \
         'week_val:FLOAT,' \


src_path = "user_log_fileC.txt"


class Split(beam.DoFn):


def parse_file(element):
  for line in csv.reader([element], quotechar='"', delimiter=',', quoting=csv.QUOTE_ALL):
      line = [s.replace('\"', '') for s in line]
      line = [s.replace('', '0') for s in line]
      clean_line = '","'.join(line)
      final_line = '"'+ clean_line +'"'
      return final_line



def main():

   p = beam.Pipeline(options=PipelineOptions())

   (p
      | 'ReadData' >> beam.io.textio.ReadFromText(src_path)
      | 'ParseCSV' >> beam.ParDo(parse_file())
      | 'WriteToBigQuery' >> beam.io.WriteToBigQuery('{0}:msft.trading_data'.format(PROJECT), schema=schema,
        write_disposition=beam.io.BigQueryDisposition.WRITE_APPEND)
   )

   p.run()

if __name__ == '__main__':
  logger = logging.getLogger().setLevel(logging.INFO)
  main()
