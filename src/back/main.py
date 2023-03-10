import json
import decimal
import uuid
import boto3
from boto3.dynamodb.conditions import Key, Attr

def helloworld(event, context):
    try:
        dynamodb = boto3.resource('dynamodb')
        table = dynamodb.Table('machin')
        method = event["httpMethod"]
        if method== "GET":
            scan = table.scan()
            data = scan['Items']
            while 'LastEvaluatedKey' in scan:
                scan = table.scan(ExclusiveStartKey=scan['LastEvaluatedKey'])
                data.extend(scan['Items'])
            return {
                    'statusCode': 200,
                    'headers': { 'Access-Control-Allow-Origin': '*', 'Content-Type': 'application/json' },
                    'body': json.dumps(data, default=to_serializable)
                }
        elif method == "POST":
            if not "body" in event:
                return {
                    'statusCode': 400
                }
            uuidMachin = str(uuid.uuid4())
            body = json.loads(event["body"])
            body["uuid"] = uuidMachin
            response = table.put_item(Item=body)
            return {
                    'statusCode': 200,
                    'headers': { 'Access-Control-Allow-Origin': '*', 'Content-Type': 'application/json' },
                    'body': json.dumps(body)
                }
    except Exception as ex:
        return {
            'statusCode': 500,
                'headers': { 'Access-Control-Allow-Origin': '*', 'Content-Type': 'application/json' },
                'body': json.dumps({'event': event, 'exception': ex.__str__()})
        }

def to_serializable(val):
    """JSON serializer for objects not serializable by default"""

    if type(val) is decimal.Decimal:
        return int(val)

    return val