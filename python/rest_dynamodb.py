import boto3
import logging
import json
import decimal

dynamodb_client = boto3.resource("dynamodb")

log = logging.getLogger()
log.setLevel(logging.INFO)

class DecimalEncoder(json.JSONEncoder):
    def default(self, o) :
        if isinstance(o,decimal.Decimal):
            return float(o)

        return super(DecimalEncoder,self).default(o)

def lambda_handler(event, context):

    log.info("Lambda {} begin execution:".format(context.function_name))
    log.info("the event that triggered lambda is: ")
    log.info(json.dumps(event))

    inventory_table = dynamodb_client.Table('inventory')
    response = inventory_table.scan()

    log.info("Lambda finished execution succesfully")

    return {
        "statusCode": "200",
        "body": json.dumps(response,cls=DecimalEncoder),
        "headers": {
            'Content-Type': 'application/json'
        }
    }
