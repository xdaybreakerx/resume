import json
import boto3

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("cloud-resume")

def lambda_handler(event, context):
    try:
        response = table.get_item(Key={
        'id':'0'
    })
        website_views = response['Item']['website_views']
        website_views = website_views + 1
        response = table.put_item(Item={
                'id':'0',
                'website_views': website_views
        })
        return website_views
    except Exception as e:
        return (f"Error updating views: {e}")



    