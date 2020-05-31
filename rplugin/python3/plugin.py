import pynvim
import threading
import socket

class Message:
    def __init__(self, name, **kwargs):
        self.data['msg'] = name
        self.data = kwargs

    @property
    def name(self):
        return self.data['msg']

    def dumps(self):
        json.dumps(self.data.encode('utf-8'))

    @classmethod
    def loads(cls, data: str):
        data = json.loads(data.encode('utf-8'))
        self = cls()
        self.data = data
        return self

nvim = None
def print(args):
    nvim.out_write(args + '\n')

# Seconds
TICK_TIME = .1

class ServerConnection:
    def __init__(self, servername):
        self._address = servername
        self._socket = None
        pass

    def start_or_connect(self):
        self.start()
        self.connect()
        pass

    def start(self):
        pass

    def connect(self):
        self._socket = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        self._socket.connect(server_address)
        pass

@pynvim.plugin
class TestPlugin(object):
    def __init__(self, _nvim):
        self.nvim = _nvim
        global nvim
        nvim = self.nvim

        self.active = False
        self.connection = ServerConnection('./uds_socket')

    @pynvim.command('TestCommand', nargs='*', range='')
    def testcommand(self, args, range):
        self.nvim.current.line = ('Command with args: {}, range: {}'
                                  .format(args, range))

    @pynvim.autocmd('FocusGained', pattern="*", sync=False)
    def on_focus_gained(self):
        self.active = True

    @pynvim.autocmd('CursorMoved', pattern='*', sync=False)
    def on_cursor_n(self):
        self.active = True

    @pynvim.autocmd('CursorMovedI', pattern='*', sync=False)
    def on_cursor_i(self):
        self.active = True

    def start_timer(self):
        self.timer = threading.Timer(TICK_TIME, self.handle_timer)

    def handle_timer(self):
        available = self.connection.start_or_connect()
        if not available:
            return

        self.send_heartbeat()
        if self.active:
            con.send_active()
            self.active.clear()

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
import sys
import subprocess
import shlex
import json
