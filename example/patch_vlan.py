import requests

headers = {
    'Content-Type': 'application/yang-data+json',
}

data = '{"config":{"name":"lab-test-vlan33"},"vlan-id":33}'

response = requests.patch('http://172.31.57.16:8538/restconf/data/running/openconfig-vlan:vlans/vlan=33/config/vlan-id', headers=headers, data=data, auth=('ADMIN', 'ADMIN'))
print (response.status_code)
