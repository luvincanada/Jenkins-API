import requests
import os
import json
import time

class RestCalls():

    def __init__(self, ip_address, port=80, username=None, password=None):
        self.BasePath = '/restconf/data/running/openconfig-'
        #self.BasePath = ''
        self.Accept = [
            'application/yang.data+{fmt}',
            'application/yang.errors+{fmt}',
        ]
        self.ContentType = 'application/yang.data+{fmt}'
        session = requests.Session()
        self.Format = 'json'
        if username is not None and password is not None:
            session.auth = (username, password)
        session.verify = False
        session.headers.update({
            'Accept': ','.join([
                accept.format(fmt=self.Format) for accept in self.Accept
            ]),
            'Content-Type': self.ContentType.format(fmt=self.Format),
        })
        self._session = session
        self._host = '{scheme}://{ip}:{port}{basePath}'.format(
            scheme='http',
            ip=ip_address,
            port=port,
            basePath=self.BasePath
        )
        self.headers = {
            'Content-Type': 'application/yang-data+json',
        }
        self.auth  = (username, password)

    def put(self, data, endpoint):
        url = self._host + endpoint
        print(url)
        res = requests.put(url, headers=self.headers, data=data, auth=self.auth)
        return res

    def post(self, data, endpoint):
        url = self._host + endpoint
        print(url)
        res = requests.post(url, headers=self.headers, data=data, auth=self.auth)
        return res

    def patch(self, data, endpoint):
        url = self._host + endpoint
        print(data)
        print(url)
        res = requests.patch(url, headers=self.headers, data=data, auth=self.auth)
        return res

    def get(self, endpoint='', **kwargs):
        url = self._host + endpoint
        print(url)
        if 'content' not in kwargs:
            kwargs = {'content': 'config'}
        print(url)
        #res = self._session.get(url, params=kwargs)
        res = requests.get(url, headers=self.headers, auth=self.auth)
        return res

    def delete(self, endpoint):
        url = self._host + endpoint
        print(url)
        #res = self._session.delete(url)
        res = requests.delete(url, auth=self.auth)
        #res = requests.delete('http://172.31.57.16:8538/restconf/data/running/openconfig-vlan:vlans/vlan=33', auth=('ADMIN', 'ADMIN'))
        return res
    
def get_session():
    ip = os.environ.get('SWITCH_IP')
    print(ip)
    port = os.environ.get('SWITCH_PORT')
    print(port)
    user = os.environ.get('REST_USER')
    print(user)
    pswd = os.environ.get('REST_PSWD')
    print(pswd)
    rest_session = RestCalls(ip,port,user,pswd)
    return rest_session

def get(uri=''):
    rest_session = get_session()
    resp = rest_session.get(uri)
    return resp

def delete(uri=''):
    rest_session = get_session()
    resp = rest_session.delete(uri)
    #resp = requests.delete('http://172.31.57.16:8538/restconf/data/running/openconfig-vlan:vlans/vlan=33', auth=('ADMIN', 'ADMIN'))
    #time.sleep(1)
    #data = '{"config":{"name":"lab-test-vlan33"},"vlan-id":33}'
    #response = requests.delete('http://172.31.57.16:8538/restconf/data/running/openconfig-vlan:vlans/vlan=33', auth=('ADMIN', 'ADMIN'))
    return resp

def post(uri='',data=None):
    print(data)
    rest_session = get_session()
    resp = rest_session.post(data,uri)
    return resp

def put(uri='',data=None):
    print(data)
    rest_session = get_session()
    resp = rest_session.put(data,uri)
    return resp

def patch(uri='',data=None):
    print(data)
    rest_session = get_session()
    #resp = rest_session.patch(data,uri)
    headers = {
        'Content-Type': 'application/yang-data+json',
    }
    #data = '{"config":{"name":"lab-test-vlan33"},"vlan-id":33}'
    #if 'vlan' in data:
    #    resp = requests.patch('http://172.31.57.16:8538/restconf/data/running/openconfig-vlan:vlans/vlan=33/config/vlan-id', headers=headers, data=data, auth=('ADMIN', 'ADMIN'))
    #else:
    resp = rest_session.patch(data,uri)
    return resp

