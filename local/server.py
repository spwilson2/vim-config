import argparse

import time
import os
import json

import threading
import socket
import socketserver
import daemon

# Every second
HEARTBEAT_TIMEOUT = 1 * 10**9

def gettime() -> int:
    return time.monotonic_ns()

# Data to maintain:
class ServerData:
    def __init__(self):
        self.clients = {}
        self.mru_clients = []
        self.lock = threading.Lock()

    def _update_cache(self):
        curtime = gettime()
        to_del = []
        for client, ctime in self.clients.items():
            if ctime - curtime > HEARTBEAT_TIMEOUT:
                to_del.append(client)

        for c in to_del:
            del self.clients[c]
            self.mru_clients.remove(c)

    def client_heartbeat(self, client):
        self.clients[client] = gettime()

    def client_active(self, client):
        print(self.mru_clients)
        if client in self.mru_clients:
            self.mru_clients.remove(client)
        self.mru_clients.append(client)
        self.client_heartbeat(client)

    def mru(self):
        self._update_cache()
        if not self.mru_clients:
            return None
        return self.mru_clients[-1]


MESSAGES = '''
active
ack-active
hearbeat
ack-hearbeat

mru-request
mru-response
'''

# Messages:
# { msg: "<message-name>" }
# active, heartbeat, mru-response
# { client: "<server-name>" }
#

class Server:
    def __init__(self, data):
        self.data = data
        self.handlers = {
                'active': self.handle_active,
                'hearbeat': self.handle_hearbeat,
                'mru-request': self.handle_mru_request,
                }

    @staticmethod
    def get_clientname(data):
        try:
            if not data['client']:
                raise Exception('Message contained a null client')
            return data['client']
        except IndexError: 
            print('Message did not contain "client" as expected')
            raise

    def handle_hearbeat(self, con, data):
        client = self.get_clientname(data)
        with self.data.lock:
            self.data.client_heartbeat(client)
        con.send(json.dumps({
            'msg': 'ack-hearbeat',
            'client': client,
            }).encode('utf-8'))

    def handle_active(self, con, data):
        client = self.get_clientname(data)
        with self.data.lock:
            self.data.client_active(client)
        con.send(json.dumps({
            'msg': 'ack-active',
            'client': client,
            }).encode('utf-8'))

    def handle_mru_request(self, con, data):
        with self.data.lock:
            mru = self.data.mru()
        con.send(json.dumps({
            'msg': 'mru-response',
            'mru': mru,
            }).encode('utf-8'))

    def handle(self, con, request):
        if 'msg' not in request:
            print('Received invalid message:')
            print('\t\t', request)
            return

        if request['msg'] not in self.handlers:
            print('Received invalid message type:')
            print('\t\t', request)
            return

        return self.handlers[request['msg']](con, request)


class Handler(socketserver.BaseRequestHandler):
    _server = None

    def handle(self):
        while True:
            data = self.request.recv(1024)
            if not data:
                print('Client disconnected before data was received.')
                return
            parsed = json.loads(data)
            self._server.handle(self.request, parsed)

class MultithreadedServer(socketserver.ThreadingMixIn, socketserver.UnixStreamServer):
    pass

def parse_args(args):
    parser = argparse.ArgumentParser()
    parser.add_argument('servername', help='Name to use for the server')
    return parser.parse_args(args)

def main(args):
    server = Server(ServerData())
    Handler._server = server
    if os.path.exists(args.servername):
        os.unlink(args.servername)
    with MultithreadedServer(args.servername, Handler) as s:
        s.serve_forever()
    os.unlink(args.servername)

def entrypoint():
    import sys
    import os
    import daemon
    with daemon.DaemonContext(detach_process=True):
        os._exit(main(parse_args(sys.argv[1:])))

if __name__ == '__main__':
    entrypoint()
