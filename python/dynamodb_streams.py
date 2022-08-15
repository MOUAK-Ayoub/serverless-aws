import boto3
import logging
import json


dynamodb_client = boto3.resource("dynamodb")
sns_client = boto3.client("sns")
log = logging.getLogger()
log.setLevel(logging.INFO)
MAX_PRICE = 1000
sns_topic_arn="arn:aws:sns:us-east-1:593048217073:product_topic_notification"

# If the price of an item is greater than 1000


def lambda_dynamodb_streams_handler(event, context):

    log.info("Lambda {} begin execution:".format(context.function_name))
    log.info("the event that triggered lambda is: ")
    log.info(json.dumps(event))

    for record in event['Records']:
        if record['eventName'] == 'MODIFY':
            log.info("the record is {}".format(json.dumps(record)))
            price = record['dynamodb']['NewImage']['Price']['S']
            product_name = record['dynamodb']['NewImage']['Name']['S']
            if int(price) > 100:
                message = "the price {} of {} is greater than the max {} ".format(
                    price, product_name, MAX_PRICE)
                log.info(message)

                response = sns_client.publish(
                    TargetArn=sns_topic_arn,
                    Message=json.dumps({'default': json.dumps(message)})
                )
    log.info("Lambda finished execution succesfully")
