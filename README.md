# MSFT
Sample Schema and APIs

The project has the following assumptions:

    - The data format would be in CSV
    
    - GCP services are used and leveraged where ever possible
 
##Tech Stack:
    
    - Python, pip, virtualenv
    
    - PostgreSQL/ BigQuery
    
    - Flask, Flask-RESTful, Flask-WTF
    
    - Pub-Sub, DataFlow, Apache Beam
 
 
 ##Overall Workflow
 
  - Our trading data is published to a GCP Pub/Sub topic.
  
  - For the streaming data, we will connect to Pub/Sub and transform(check list 1 for the list of transformations) the data using Python and Beam .
  
  - After transforming the data, Beam will then connect to BigQuery and append the data to our table.
  
  - For batch load, the data is imported into PSQL and then transformed using Python and Beam
  
  - To carry out analysis we can connect to BigQuery using a variety of tools such as Tableau and Python.
