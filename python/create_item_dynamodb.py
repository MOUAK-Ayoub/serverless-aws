from io import StringIO
import boto3
import logging
import json
import csv

dynamodb_client = boto3.resource("dynamodb")
s3_client = boto3.client("s3")
log = logging.getLogger()
log.setLevel(logging.INFO)


def lambda_S3_to_dynamodb_handler(event, context):

    log.info("Lambda {} begin execution:".format(context.function_name))
    log.info("the event that triggered lambda is: ")
    log.info(json.dumps(event))

    log.info("Get name of object uploaded to S3 ")

    bucket = event["Records"][0]["s3"]["bucket"]["name"]
    item = event["Records"][0]["s3"]["object"]["key"]

    log.info("The {} is uploaded on bucket {}".format(item, bucket))

    data = s3_client.get_object(Bucket=bucket, Key=item)
    contents = data['Body'].read().decode('utf-8')

    buffer = StringIO(contents)
    reader = csv.DictReader(buffer)

    inventory_table = dynamodb_client.Table('inventory')

    for row in reader:
        inventory_table.put_item( Item={
            'product_id': row['itemId'],
            'Name': row['Name'],
            'Price': row['Price']
        })
    log.info("Lambda finished execution succesfully")
