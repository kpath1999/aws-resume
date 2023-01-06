import boto3
import json

def lambda_handler(event, context):
    dynamoDB = boto3.client('dynamodb')
    
    # Update counter within DynamoDB
    response = dynamoDB.update_item(
            TableName = 'VisitorCount',
            Key = {'ID' : {'S' : '#'}},
            UpdateExpression = 'SET Visits = Visits + :inc',
            ExpressionAttributeValues = {':inc' : {'N' : '1'}},
            ReturnValues='UPDATED_NEW'
    )
    
    # For CloudWatch monitoring
    print(event)
    
    counter = 0
    if (event['httpMethod'] == 'POST'):
        counter = response['Attributes']['Visits']['N']
    
    return {
        'statusCode': '200',
        'body': counter
    }