import boto3
import logging

dynamodb_client=boto3.client("dynamodb")

log=logging.getLogger()
log.setLevel(logging.INFO)

def lambda_handler(event,context):

    log.info("Lambda {} begin execution:".format(context.function_name))

    dynamodb_client.create_backup(TableName='inventory',
                    BackupName='backupNew')
    
    log.info("Lambda finished execution succesfully")
    
