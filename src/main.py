import json
import boto3
from boto3.dynamodb.conditions import Key, Attr

def helloworld(event, context):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('machin')
    scan = table.scan()
    data = scan['Items']
    while 'LastEvaluatedKey' in scan:
        scan = table.scan(ExclusiveStartKey=scan['LastEvaluatedKey'])
        data.extend(scan['Items'])
    return {
            'statusCode': 200,
            'headers': { 'Content-Type': 'application/json' },
            'body': json.dumps(data)
        }

def posthello(event, context):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('machin')
    response = table.put_item(event["body"])
    return {
            'statusCode': 200,
            'headers': { 'Content-Type': 'application/json' },
            'body': json.dumps(response)
        }
