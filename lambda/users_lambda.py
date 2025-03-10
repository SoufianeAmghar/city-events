import json
import boto3
import os
import requests
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
table_name = os.environ['USERS_TABLE_NAME']
table = dynamodb.Table(table_name)

def get_geo_info(ip_address):
    try:
        response = requests.get(f"http://ip-api.com/json/{ip_address}")
        response.raise_for_status() # Raise HTTPError for bad responses (4xx or 5xx)
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error getting geo info: {e}")
        return None

def lambda_handler(event, context):
    try:
        body = json.loads(event['body'])
        name = body.get('name')
        age = body.get('age')  # User provided location
        interests = body.get('interests')

        if not name or not age or not interests:
            return {
                'statusCode': 400,
                'body': json.dumps({'message': 'Missing mandatory inputs: name, age, interests'})
            }

        # Get IP address from request headers (or event context if available)
        ip_address = event.get('requestContext', {}).get('identity', {}).get('sourceIp')

        if not ip_address:
            return {
                'statusCode': 400,
                'body': json.dumps({'message': 'Could not determine IP address'})
            }

        geo_info = get_geo_info(ip_address)

        if geo_info:
            geo_info_to_save = {k: v for k, v in geo_info.items() if isinstance(v, (str, int, float, bool))} #sanitize geo_info
        else:
            geo_info_to_save = {}

        item = {
            'name': name,
            'age': age,
            'interests': interests,
            'ip_address': ip_address,
            'geo_info': geo_info_to_save,
            'creation_date': datetime.now()
        }

        table.put_item(Item=item)

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'User created successfully', 'user': item})
        }

    except json.JSONDecodeError:
        return {
            'statusCode': 400,
            'body': json.dumps({'message': 'Invalid JSON in request body'})
        }
    except Exception as e:
        print(f"Error: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Internal server error', 'error': str(e)})
        }