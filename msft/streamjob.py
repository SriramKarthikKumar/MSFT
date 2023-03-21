from apache_beam.options.pipeline_options import PipelineOptions
from google.cloud import pubsub_v1
from google.cloud import bigquery
import apache_beam as beam
import logging
import argparse
import sys, datetime
import re


PROJECT="msft-sample"
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
         'week_val:FLOAT,'
TOPIC = "projects/msft-sample/topics/training_data"
seconds_in_day = 60 * 60 * 24


def clean(data):
    result = []
    try:
        line = [s.replace('\"', '') for s in data]
        line = [s.replace('', '0') for s in line]
    except:
        print("There was an error with the regex search")
    result = [x.strip() for x in line]
    result = [x.replace('"', "") for x in result]
    res = ','.join(result)
    return res


def main(argv=None):

   parser = argparse.ArgumentParser()
   parser.add_argument("--input_topic")
   parser.add_argument("--output")
   known_args = parser.parse_known_args(argv)

   def get_window(element,  timestamp=beam.DoFn.TimestampParam):
        return {"timestamp": datetime.fromtimestamp(int(timestamp) + 1), "avg_temperature_last_20days": element}


   p = beam.Pipeline(options=PipelineOptions())
   #Rolling average for 20 days being computed and persisted every second
   (p
      | 'ReadData' >> beam.io.ReadFromPubSub(topic=TOPIC).with_output_types(bytes)
      | "Clean Data" >> beam.Map(clean)
      | 'WriteToBigQuery' >> beam.io.WriteToBigQuery('{0}:test.stock'.format(PROJECT), schema=schema,
        write_disposition=beam.io.BigQueryDisposition.WRITE_APPEND)
      | 'window' >> beam.WindowInto(window.SlidingWindows(20 * seconds_in_day, 1 * seconds_in_day))  # Window of 10 days, with a Period of 1 day
      | beam.combiners.Mean.Globally().without_defaults()
      | "get window value" >> beam.Map(get_window)
      | 'WriteToBigQuery' >> beam.io.WriteToBigQuery('{0}:test.calculations'.format(PROJECT), schema=schema,
   ))

   result = p.run()
   result.wait_until_finish()


if __name__ == '__main__':
  logger = logging.getLogger().setLevel(logging.INFO)
  main()
