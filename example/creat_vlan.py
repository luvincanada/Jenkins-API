import requests

headers = {
    'Content-Type': 'application/yang-data+json',
}

data = '{"vlan-id":33}'

response = requests.post('http://172.32.57.16:8538/restconf/data/running/openconfig-vlan:vlans', headers=headers, data=data, auth=('ADMIN', 'ADMIN'))
