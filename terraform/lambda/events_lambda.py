import json
import boto3
import os

dynamodb = boto3.resource('dynamodb')
events_table = dynamodb.Table(os.environ['EVENTS_TABLE_NAME'])
users_table = dynamodb.Table(os.environ['USERS_TABLE_NAME'])
s3 = boto3.client('s3')


def find_best_event(user_id, all_events):
    try:
        user_response = users_table.get_item(Key={'user_id': user_id})
        user = user_response.get('Item')
        if not user:
            return None

        user_interests = user.get('interests', [])
        user_age = user.get('age')
        user_geo = user.get('geo_info', {})
        user_country = user_geo.get('country')

        best_event = None
        best_score = -1

        for event in all_events:
            score = 0
            event_interests = event.get('interests', [])
            event_location = event.get('location')

            for interest in user_interests:
                if interest in event_interests:
                    score += 1

            if user_country and event_location and user_country == event_location:
                score += 2

            if user_age and event.get('age_range'):
                min_age, max_age = map(int, event['age_range'].split('-'))
                if min_age <= user_age <= max_age:
                    score += 1

            if score > best_score:
                best_score = score
                best_event = event

        return best_event

    except Exception as e:
        print(f"Error finding best event: {e}")
        return None

def lambda_handler(event, context):
    try:
        request_path = event['requestContext']['resourcePath']
        body = json.loads(event['body'])

        if request_path == '/events/create-event':
            # Handle Event Creation
            event_id = body.get('event_id')
            name = body.get('name')
            location = body.get('location')
            interests = body.get('interests')
            date = body.get('date')
            official_url = body.get('official_url')
            age_range = body.get('age_range')
            media_urls = []

            if not event_id or not name or not location or not interests or not date:
                return {
                    'statusCode': 400,
                    'body': json.dumps({'message': 'Missing mandatory inputs: event_id, name, location, interests, date'})
                }

            if body.get('media'):
                for media in body['media']:
                    media_url = f"s3://{os.environ['MEDIA_BUCKET_NAME']}/{event_id}/{media['filename']}"
                    s3.put_object(Bucket=os.environ['MEDIA_BUCKET_NAME'], Key=f"{event_id}/{media['filename']}", Body=bytes(media['data'], 'utf-8'))
                    media_urls.append(media_url)

            item = {
                'event_id': event_id,
                'name': name,
                'location': location,
                'interests': interests,
                'date': date,
                'official_url': official_url,
                'age_range': age_range,
                'media_urls': media_urls
            }

            events_table.put_item(Item=item)

            return {
                'statusCode': 200,
                'body': json.dumps({'message': 'Event created', 'event': item})
            }

        elif request_path == '/events/find-event':
            # Handle Find Event
            user_id = body.get('user_id')

            if not user_id:
                return {
                    'statusCode': 400,
                    'body': json.dumps({'message': 'Missing mandatory input: user_id'})
                }

            all_events_response = events_table.scan()
            all_events = all_events_response.get('Items', [])
            best_event = find_best_event(user_id, all_events)

            if best_event:
                return {
                    'statusCode': 200,
                    'body': json.dumps({'message': 'Best event found', 'best_event': best_event})
                }
            else:
                return {
                    'statusCode': 404,
                    'body': json.dumps({'message': 'No best event found'})
                }

        else:
            return {
                'statusCode': 404,
                'body': json.dumps({'message': 'Invalid endpoint'})
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