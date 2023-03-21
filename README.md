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
 
 
 ##Overall Workflow (Pls look at the attached picture in the zip file)
 
  - Our trading data is published to a GCP Pub/Sub topic.
  
  - For the streaming data, we will connect to Pub/Sub and transform(check list 1 for the list of transformations) the data using Python and Beam .
  
  - After transforming the data, Beam will then connect to BigQuery and append the data to our table.
  
  - For batch load, the data is imported into PSQL and then transformed using Python and Beam
  
  - To carry out analysis we can connect to BigQuery using a variety of tools such as Tableau and Python.
  
  
 ## Tech Reasoning for the assumptions:
 
     - Pub-Sub is used to leverage on the auto-scaling and the min down time features for the streaming data.
     
     - Apache Beam's Python SDK is used for the processing of the data and to globally find the mean using the window(20,50 & 200 days with timestamp for          every second to aggregate) feature
     
     - The data is persisted in the Big query for easy assumption by the front end APIS and also can help to integrate any cloud visulaization tools.
     
     - PSQL is chosen for batch procesing as it is an open source offering and it is makes the tech stack easier to start with for beginners. 
     
     - Dataflow is chosen for easier pipeline building. Similar AWS(GLue) offering can also be chosen if the tech stack is moved to AWS.
     
    
