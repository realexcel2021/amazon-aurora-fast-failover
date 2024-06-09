_A = '%H:%M:%S'
import sys, subprocess
subprocess.call('pip install cfnresponse -t /tmp/ --no-cache-dir'.split(), stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
sys.path.insert(1, '/tmp/')
import io, os, json, boto3, shutil, cfnresponse
from zipfile import ZipFile
from botocore.exceptions import ClientError as boto3_client_error

def zip_directory(path):
    for root, dirs, files in os.walk(path):
        for file in files:
            yield os.path.join(root, file), file[len(path) + len(os.sep):]

def make_zip_file_bytes(path):
    with io.BytesIO() as buffer:
        with ZipFile(buffer, 'w') as zip_file:
            for file, arcname in zip_directory(path=path):
                zip_file.write(file, arcname)
        return buffer.getvalue()

def handler(event, context):
    print(json.dumps(event))
    resource_properties = event['ResourceProperties']
    layer_name = "amazon-aurora-failover-layer" #resource_properties['LayerName']
    region = os.environ["Region"] #resource_properties['Region']
    packages = ["requests", "cfnresponse", "psycopg2-binary"] #resource_properties['Packages']

    session = boto3.Session(region_name=region)
    lambda_client = session.client('lambda')

    if event['RequestType'] in ['Create', 'Update']:
        subprocess.call(('pip install ' + ' '.join(packages) + ' -t /tmp/lambda-layer --no-cache-dir').split(), stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        shutil.copyfile(os.path.realpath(__file__), '/tmp/lambda-layer/multi_region_db.py')
        try:
            response = lambda_client.publish_layer_version(
                LayerName=layer_name,
                Content={'ZipFile': make_zip_file_bytes('/tmp/lambda-layer')},
                CompatibleRuntimes=['python3.9', 'python3.10', 'python3.11', 'python3.12'],
                CompatibleArchitectures=['x86_64', 'arm64']
            )
            return cfnresponse.send(event, context, cfnresponse.SUCCESS, {}, response['LayerVersionArn'])
        except boto3_client_error as e:
            print('Failed to Deploy Lambda Layer: ' + str(e.response))
            return cfnresponse.send(event, context, cfnresponse.FAILED, {})

    if event['RequestType'] == 'Delete':
        try:
            response = lambda_client.list_layer_versions(LayerName=layer_name)
            for version in response['LayerVersions']:
                lambda_client.delete_layer_version(LayerName=layer_name, VersionNumber=version['Version'])
        except boto3_client_error as e:
            print('Failed to Delete Layer Versions: ' + str(e.response))
            return cfnresponse.send(event, context, cfnresponse.FAILED, {})
        return cfnresponse.send(event, context, cfnresponse.SUCCESS, {})

import dateutil.tz
from datetime import datetime, timedelta

class Functions:
    def __init__(self):
        pass

    def add_five_seconds(self, start_time):
        return (datetime.strptime(str(start_time), _A) + timedelta(seconds=5)).strftime(_A)

    def subtract_five_seconds(self, start_time):
        return (datetime.strptime(str(start_time), _A) + timedelta(seconds=-5)).strftime(_A)

    def add_time(self, label, data):
        tz = dateutil.tz.gettz('US/Pacific')
        current_time = datetime.now(tz)
        while datetime.strptime(label[-1], _A) + timedelta(seconds=9) < current_time:
            label.pop(0)
            data.pop(0)
            label.append(self.add_five_seconds(label[-1]))
            data.append('0')

def get_db_credentials(db_identifier):
    secrets_client = boto3.client('secretsmanager')
    try:
        response = secrets_client.get_secret_value(SecretId=os.environ['REGIONAL_' + db_identifier.upper() + '_DB_SECRET_ARN'])
    except boto3_client_error as e:
        raise Exception('Failed to Retrieve ' + db_identifier + ' Database Secret: ' + str(e))
    else:
        return json.loads(response['SecretString'])

def update_dns_record(fqdn, new_value, hosted_zone_id, ttl=1, record_type='CNAME'):
    route53_client = boto3.client('route53')
    try:
        route53_client.change_resource_record_sets(
            ChangeBatch={
                'Changes': [{
                    'Action': 'UPSERT',
                    'ResourceRecordSet': {
                        'Name': fqdn,
                        'ResourceRecords': [{'Value': new_value}],
                        'TTL': ttl,
                        'Type': record_type
                    }
                }]
            },
            HostedZoneId=hosted_zone_id
        )
    except boto3_client_error as e:
        raise Exception('Failed to Update DNS Record: ' + str(e))
    return True