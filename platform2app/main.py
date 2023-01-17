import boto3

dynamodb = boto3.client('dynamodb', endpoint_url='http://13.39.17.55:8000')

response = dynamodb.list_tables()

print(response)