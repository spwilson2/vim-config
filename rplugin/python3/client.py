

# TODO: 
# Capabilities:
# -r : reuse the most recently focused editing server
# -s <name> : open file using the <name>
# --exists <name> : check if the given server name exists
#
# Server:
# - Server manages list of all active servers
#  - If no client heartbeat, exit
#
# Client:
# - Provides interface to interact between clients and editor
# - Starts the server if it is not currently running
#
# To add to vim:
# - Maintain status:
#   - Register server name when started
#   - Heartbeat to the server
#   - De-register when disconnected
# - Maintain latest focus:
#   - Send notification to server when status is selected

import argparse
import os
import re
import sys
import subprocess
import shlex
import json
import socket

from plugin import Message
import pynvim

REUSE_HELP = 'Reuse the most recently active editor'
SERVER_HELP = ('Open up a file using the server with given name. '
    'If no such server exists, create it.')

class ConnectionServer():
    def __init__(self):
        pass

    def connect(self):
        server_address = './uds_socket'
        self.socket = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        self.socket.connect(server_address)

    def get_mru(self) -> str:
        self.socket.sendall(Message('mru-request').dumps())
        data = self.socket.recv(1024)
        msg = Message.loads(data)
        if msg.name != 'mru-response':
            raise Exception('Received invalid response from server: ', str(msg))
        return msg.client

def remote_open_file(servername, filepath):
    filepath = re.sub(r' "\\\'', r'\\1', filepath)
    client = pynvim.attach('socket', path=servername)
    # TODO Add a command inside vim to 
    # allow signaling when this file is closed.
    client.command('tabe %s' % filepath)
    client.close()

def parse_args(argv: [str]):

    parser = argparse.ArgumentParser()
    parser.add_argument('--remote', '-r', action='store_true', help=REUSE_HELP)
    parser.add_argument('--server', '-s', type=str, help=SERVER_HELP)
    parser.add_argument('files', type=str, nargs='*')

    if '--' in argv:
        argv = argv[:argv.index('--')]

    args = parser.parse_args()
    return args

def main(args):
    # TODO: If remote, simply get mru and attempt to connect
    if args.remote:
        con = ConnectionServer()
        # TODO handle failure
        con.connect()
        mru = con.get_mru()
        if mru:
            remote_open_file()


    return 0

def entrypoint():
    os._exit(main(parse_args(sys.argv[1:])))

if __name__ == '__main__':
    #remote_open_file('nvim.sock', 'editor .py\\')
    entrypoint()
