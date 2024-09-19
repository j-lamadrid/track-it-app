import firebase_admin
from firebase_admin import credentials, firestore
import json
import sys
from datetime import datetime

# Command-line arguments
cred_fp = sys.argv[1]  # Firebase credentials filepath
collection = sys.argv[2]  # Collection name

# Initialize Firebase app
cred = credentials.Certificate(cred_fp)
firebase_admin.initialize_app(cred)

# Firestore client
db = firestore.client()

# Get the documents from the specified collection
docs = db.collection(collection).stream()

# Store the data
data = {}
for doc in docs:
    data[doc.id] = doc.to_dict()

# Format the output file name with the collection and today's date
today = datetime.now().strftime('%Y-%m-%d')
output_filename = f'exports/{collection}_{today}.json'

# Write the data to a JSON file
with open(output_filename, 'w') as f:
    json.dump(data, f, indent=4)

print(f'Data has been written to {output_filename}')